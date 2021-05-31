import 'package:flutter/material.dart';

import 'profile.dart';
import 'sites.dart';
import 'visits.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('TrailYa'),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Visits',
                icon: Icon(Icons.place_outlined),
              ),
              Tab(
                  text: 'Site alerts',
                  icon: Icon(Icons.notification_important_rounded)),
              Tab(
                text: 'Profile',
                icon: Icon(Icons.person),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VisitsPage(),
            ExposedSitesPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
