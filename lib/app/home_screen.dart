import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/profile_screen.dart';
import 'package:trailya/app/sites_screen.dart';
import 'package:trailya/app/visits_screen.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/services/location_service.dart';
import 'package:trailya/services/sites_service.dart';

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
        ),
        child: _buildContent(),
      ),
    );
  }

  DefaultTabController _buildContent() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('trailya'),
          ),
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
}
