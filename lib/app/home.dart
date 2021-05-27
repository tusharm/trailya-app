import 'package:flutter/material.dart';

import 'checkins.dart';
import 'exposed_sites.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Am I Linked?'),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_walk)),
              Tab(icon: Icon(Icons.notification_important_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CheckinsPage(),
            ExposedSitesPage(),
          ],
        ),
      ),
    );
  }
}

