import 'package:flutter/material.dart';
import 'package:trailya/model/filters.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/sites_notifier.dart';

class ClearFilterFAB extends StatelessWidget {
  ClearFilterFAB({
    required this.locationNotifier,
    required this.sitesNotifier,
    required this.filters,
  });

  final LocationNotifier locationNotifier;
  final SitesNotifier sitesNotifier;
  final Filters filters;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        onPressed: _clearFilters,
        tooltip: 'Clear filters',
        backgroundColor: Colors.indigo,
        child: Icon(Icons.clear),
      ),
    );
  }

  void _clearFilters() {
    filters.clearAll();
  }
}
