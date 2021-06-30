import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/profile_screen.dart';
import 'package:trailya/app/sites_screen.dart';
import 'package:trailya/app/visits_screen.dart';
import 'package:trailya/app/widgets/dialog.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/services/auth.dart';
import 'package:trailya/services/location_service.dart';
import 'package:trailya/services/sites_service.dart';
import 'package:trailya/services/visits_store.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return SitesNotifier(
          sitesService: Provider.of<SitesService>(context, listen: false),
        );
      },
      child: ChangeNotifierProvider(
        create: (context) => LocationNotifier(
          locationService: Provider.of<LocationService>(context, listen: false),
          visitsStore: Provider.of<VisitsStore>(context, listen: false),
        ),
        child: _buildContent(context),
      ),
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
                    ProfileScreen(),
                  ],
                )),
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
}
