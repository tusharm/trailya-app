import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/profile_screen.dart';
import 'package:trailya/app/sites_screen.dart';
import 'package:trailya/app/visits_screen.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/services/sites_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        body: ChangeNotifierProvider(
          create: (_) => SitesNotifier(),
          child: Consumer<SitesNotifier>(
            builder: _tabViewBuilder,
          ),
        ),
      ),
    );
  }

  Widget _tabViewBuilder(BuildContext context, SitesNotifier sitesNotifier, Widget? child) {
    final sitesService = Provider.of<SitesService>(context, listen: false);
    sitesService.getSites().listen((sites) {
      sitesNotifier.refreshSites(sites);
    });

    return TabBarView(
      children: [
        VisitsScreen(sitesNotifier: sitesNotifier),
        SitesScreen(sitesNotifier: sitesNotifier),
        ProfileScreen(),
      ],
    );
  }
}
