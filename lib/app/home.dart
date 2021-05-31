import 'package:flutter/material.dart';

import 'sites.dart';
import 'visits.dart';

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
            child: Text('TrailYa'),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_walk)),
              Tab(icon: Icon(Icons.place_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VisitsPage(),
            ExposedSitesPage(),
          ],
        ),
      ),
    );
  }
}

