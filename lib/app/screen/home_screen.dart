import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/screen/profile_screen.dart';
import 'package:trailya/app/screen/sites_screen.dart';
import 'package:trailya/app/screen/visits_screen.dart';
import 'package:trailya/app/widgets/dialog.dart';
import 'package:trailya/app/widgets/waiting.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/model/user_config.dart';
import 'package:trailya/services/auth.dart';
import 'package:trailya/services/background.dart';
import 'package:trailya/services/location_service.dart';
import 'package:trailya/services/message_service.dart';
import 'package:trailya/services/visits_store.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MessageService? messageService;

  @override
  Widget build(BuildContext context) {
    // TODO: need a better way instead of chaining FutureBuilders

    return FutureBuilder<void>(
      future: scheduleBackgroundJob(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Waiting();
        }

        return FutureBuilder<VisitsStore>(
          future: VisitsStore.create(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return Waiting();
            }

            final visitsStore = snapshot.data!;
            return FutureBuilder<LocationService>(
              future: LocationService.create(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Waiting();
                }

                final locationService = snapshot.data!;
                return MultiProvider(
                  providers: [
                    Provider.value(value: visitsStore),
                    Provider.value(value: locationService),
                    ChangeNotifierProvider(create: (_) => UserConfig()),
                    SitesNotifier.create(),
                    LocationNotifier.create(),
                  ],
                  builder: (context, _) => _buildContents(context),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildContents(BuildContext context) {
    messageService = MessageService.create(context);
    final sitesNotifier = Provider.of<SitesNotifier>(context, listen: false);
    final locationNotifier =
        Provider.of<LocationNotifier>(context, listen: false);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Center(
            child: Image.asset(
              'assets/trailya.png',
              width: 90,
            ),
          ),
          elevation: 5.0,
          toolbarHeight: 120,
          actions: [
            IconButton(
              icon: Icon(Icons.logout_rounded),
              tooltip: 'Logout',
              onPressed: () => _confirmSignOut(context),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.place_outlined)),
              Tab(icon: Icon(Icons.format_list_numbered_outlined)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            VisitsScreen(
              sitesNotifier: sitesNotifier,
              locationNotifier: locationNotifier,
            ),
            SitesScreen(
              sitesNotifier: sitesNotifier,
            ),
            ProfileScreen.create(),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthentication>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );

    if (didRequestSignOut == true) {
      await _signOut(context);
    }
  }

  @override
  void dispose() {
    if (messageService != null) {
      messageService!.dispose();
    }

    super.dispose();
  }
}
