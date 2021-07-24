import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:trailya/model/filters.dart';
import 'package:trailya/model/sites_notifier.dart';

class SitesFilterFAB extends StatelessWidget {
  SitesFilterFAB({
    required this.sitesNotifier,
    required this.filters,
  });

  final SitesNotifier sitesNotifier;
  final Filters filters;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FloatingActionButton(
        onPressed: () => _onPressed(context),
        tooltip: 'Filter sites',
        backgroundColor: filters.suburb != null ? Colors.pink : Colors.indigo,
        child: Icon(Icons.place),
      ),
    );
  }

  void _onPressed(BuildContext context) async {
    final sites = sitesNotifier.sites.map((s) => s.suburb.trim()).toSet().toList();

    sites.sort();

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: DropdownSearch<String>(
              label: 'Select suburb',
              mode: Mode.DIALOG,
              showSearchBox: true,
              showClearButton: true,
              showSelectedItem: true,
              selectedItem: filters.suburb,
              items: sites,
              onChanged: (suburb) {
                filters.suburb = suburb;
                Navigator.of(context).pop(suburb = null);
              },
            ),
          );
        });
  }
}
