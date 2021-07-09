import 'package:flutter/material.dart';
import 'package:trailya/model/sites_notifier.dart';

class DateFilterFAB extends StatelessWidget {
  DateFilterFAB({required this.sitesNotifier});

  final SitesNotifier sitesNotifier;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async => _onFabPressed(context),
      label: Text('By exposure date'),
      backgroundColor: Colors.indigo,
      hoverColor: Colors.indigoAccent,
      icon: Icon(Icons.filter_alt_outlined),
    );
  }

  Future<void> _onFabPressed(BuildContext context) async {
    final sortedExposureStartTimes = sitesNotifier.sites.map((e) =>
    e.exposureStartTime).toList();

    sortedExposureStartTimes.sort();

    final date = await showDatePicker(
        context: context,
        helpText: 'Select exposure date',
        cancelText: 'Clear',
        confirmText: 'Apply',
        initialDate: sitesNotifier.selectedExposureDate ??
            sortedExposureStartTimes.last,
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now(),
        selectableDayPredicate: (datetime) =>
        !datetime.isBefore(sortedExposureStartTimes.first) &&
            !datetime.isAfter(sortedExposureStartTimes.last));

    sitesNotifier.selectedExposureDate = date;
  }
}