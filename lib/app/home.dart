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
                icon: Icon(Icons.place_outlined),
              ),
              Tab(
                  icon: Icon(Icons.notification_important_rounded)),
              Tab(
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
