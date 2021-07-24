import 'package:flutter/material.dart';
import 'package:trailya/model/filters.dart';
import 'package:trailya/model/location_notifier.dart';

class VisitFilterFAB extends StatelessWidget {
  VisitFilterFAB({
    required this.locationNotifier,
    required this.filters,
  });

  final LocationNotifier locationNotifier;
  final Filters filters;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        onPressed: () => filters.showVisitsOnly = !filters.showVisitsOnly,
        tooltip: 'My visits',
        backgroundColor: filters.showVisitsOnly ? Colors.pink : Colors.indigo,
        child: Icon(Icons.directions_walk),
      ),
    );
  }
}
