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
    return ChangeNotifierProvider(
      create: (context) {
        final notifier = SitesNotifier();
        Provider.of<SitesService>(context, listen: false)
            .getSites()
            .listen((sites) {
          notifier.refreshSites(sites);
        });
        return notifier;
      },
      child: _buildContent(),
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
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            VisitsScreen(),
            Consumer<SitesNotifier>(
              builder: (c, notifier, _) =>
                  SitesScreen(sitesNotifier: notifier),
            ),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }
}
