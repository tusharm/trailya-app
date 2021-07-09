import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:trailya/app/widgets/date_filter_fab.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/utils/date_util.dart';

class SitesScreen extends StatelessWidget {
  SitesScreen({required this.sitesNotifier});

  static DateFormat dateFormat = DateFormat('MMM dd, yyyy hh:mm a');

  final SitesNotifier sitesNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildExpansionList(sitesNotifier.filteredSites),
      floatingActionButton: DateFilterFAB(
        sitesNotifier: sitesNotifier,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildExpansionList(List<Site> sites) {
    final groupedByDate = groupBy<Site, String>(
            sites, (site) => formatDate(site.addedTime, onlyDateFormatter))
        .entries
        .toList();

    return ListView.separated(
      itemCount: groupedByDate.length + 2,
      separatorBuilder: (context, index) => Divider(
        height: 5.0,
        thickness: 0.5,
      ),
      itemBuilder: (context, index) {
        // two show dividers before the first and after the last item in the list
        if (index == 0 || index == groupedByDate.length + 1) {
          return Container();
        }

        return _buildExpansionTile(context, groupedByDate[index - 1]);
      },
    );
  }

  Widget _buildExpansionTile(
    BuildContext context,
    MapEntry<String, List<Site>> sitesForDate,
  ) {
    return ExpansionTile(
      key: PageStorageKey(sitesForDate.key),
      title: Text('${sitesForDate.key} (${sitesForDate.value.length} sites)'),
      children: _sort(sitesForDate.value).mapIndexed((index, site) {
        final postcodeText = site.postcode != null ? ', ${site.postcode}' : '';

        return ListTile(
          leading: Text('${index + 1}'),
          minLeadingWidth: 10,
          isThreeLine: true,
          dense: false,
          title: Text(site.title),
          subtitle: Text(
            '${site.address}, ${site.suburb}, ${site.state}$postcodeText\n'
            '${formatDate(site.exposureStartTime)} - ${formatDate(site.exposureEndTime)}',
          ),
          onTap: () => _showOnMap(context, site),
        );
      }).toList(),
    );
  }

  List<Site> _sort(List<Site> sites) {
    return sites.sorted((a, b) {
      var result = a.suburb.compareTo(b.suburb);
      if (result == 0) {
        result = a.title.compareTo(b.title);
        if (result == 0) {
          result = b.exposureStartTime.compareTo(a.exposureStartTime);
        }
      }
      return result;
    });
  }

  void _showOnMap(BuildContext context, Site site) {
    final tabController = DefaultTabController.of(context)!;
    tabController.animateTo(0);

    sitesNotifier.setSelectedSite(site);
  }
}
