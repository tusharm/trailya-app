import 'package:flutter/material.dart';
import 'package:trailya/model/filters.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/sites_notifier.dart';

class ExposureDateFilterFAB extends StatelessWidget {
  ExposureDateFilterFAB({
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
        onPressed: () async => _onFabPressed(context),
        tooltip: 'Filter by exposure date',
        backgroundColor: filters.exposureDate == null ? Colors.indigo : Colors.pink,
        child: Icon(Icons.calendar_today_outlined),
      ),
    );
  }

  Future<void> _onFabPressed(BuildContext context) async {
    final dates = sitesNotifier.sites
        .map((s) => s.start)
        .followedBy(locationNotifier.visits.map((e) => e.start))
        .toList();

    dates.sort();

    filters.exposureDate = await showDatePicker(
        context: context,
        helpText: 'Select exposure date',
        cancelText: 'Clear',
        confirmText: 'Apply',
        initialDate: filters.exposureDate ?? dates.last,
        firstDate: dates.first,
        lastDate: dates.last,
        selectableDayPredicate: (datetime) =>
            !datetime.isBefore(dates.first) && !datetime.isAfter(dates.last));
  }
}
