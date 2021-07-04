import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/screen/profile_screen.dart';
import 'package:trailya/app/screen/sites_screen.dart';
import 'package:trailya/app/screen/visits_screen.dart';
import 'package:trailya/app/widgets/dialog.dart';
import 'package:trailya/app/widgets/waiting.dart';
import 'package:trailya/model/config.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/services/auth.dart';
import 'package:trailya/services/location_service.dart';
import 'package:trailya/services/visits_store.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationService>(
      future: _initLocationService(context),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(body: Waiting());
        }

        return ChangeNotifierProvider(
          create: (context) => LocationNotifier(
            locationService: snapshot.data!,
            visitsStore: Provider.of<VisitsStore>(context, listen: false),
          ),
          child: _buildContent(context),
        );
      },
    );
  }

  DefaultTabController _buildContent(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Center(
            child: Text('trailya'),
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
              Tab(icon: Icon(Icons.notification_important_rounded)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: Consumer<SitesNotifier>(
            builder: (c, sitesNotifier, _) => TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Consumer<LocationNotifier>(
                      builder: (c, locationNotifier, _) => VisitsScreen(
                        sitesNotifier: sitesNotifier,
                        locationNotifier: locationNotifier,
                      ),
                    ),
                    SitesScreen(sitesNotifier: sitesNotifier),
                    Consumer<UserConfig>(
                      builder: (c, config, _) => ProfileScreen(
                        config: config,
                      ),
                    ),
                  ],
                )),
      ),
    );
  }

  Future<LocationService> _initLocationService(BuildContext context) async {
    final locationService = await LocationService.create();
    final enabled = await locationService.backgroundModeEnabled;

    if (!enabled) {
      final confirmed = await showAlertDialog(
        context,
        title: 'Enable background mode?',
        content: 'Keep tracking your visits continuously',
        cancelActionText: 'Later',
        defaultActionText: 'Enable',
      );

      if (confirmed) {
        locationService.enableBackgroundMode(true);
      }
    }
    return locationService;
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
}
