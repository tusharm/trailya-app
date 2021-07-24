import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/widgets/dialog.dart';
import 'package:trailya/app/widgets/fab/clear_filter_fab.dart';
import 'package:trailya/app/widgets/fab/exposure_date_filter_fab.dart';
import 'package:trailya/app/widgets/fab/sites_filter_fab.dart';
import 'package:trailya/model/filters.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/utils/date_util.dart';

class SitesScreen extends StatelessWidget {
  static DateFormat dateFormat = DateFormat('MMM dd, yyyy hh:mm a');

  @override
  Widget build(BuildContext context) {
    final locationNotifier = Provider.of<LocationNotifier>(context);
    final sitesNotifier = Provider.of<SitesNotifier>(context);
    final filters = Provider.of<Filters>(context);

    final filteredSites = sitesNotifier.sites
        .where((s) => filters.withinExposureDate(s))
        .where((s) => filters.filterSuburb(s))
        .toList();

    return Scaffold(
      body: _buildExpansionList(filteredSites),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: AnimatedFloatingActionButton(
        fabButtons: [
          ClearFilterFAB(
            locationNotifier: locationNotifier,
            sitesNotifier: sitesNotifier,
            filters: filters,
          ),
          ExposureDateFilterFAB(
            locationNotifier: locationNotifier,
            sitesNotifier: sitesNotifier,
            filters: filters,
          ),
          SitesFilterFAB(
            sitesNotifier: sitesNotifier,
            filters: filters,
          ),
        ],
        colorStartAnimation: Colors.indigo,
        colorEndAnimation: Colors.indigo,
        animatedIconData: AnimatedIcons.search_ellipsis,
      ),
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
            '${formatDate(site.start)} - ${formatDate(site.end)}',
          ),
          onTap: () async => _showOnMap(context, site),
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
          result = b.start.compareTo(a.end);
        }
      }
      return result;
    });
  }

  Future<void> _showOnMap(BuildContext context, Site site) async {
    if (site.lat == null || site.lng == null) {
      await showAlertDialog(
        context,
        title: site.title,
        content: 'No geolocation info to show on map',
        defaultActionText: 'OK',
      );
      return;
    }

    final tabController = DefaultTabController.of(context)!;
    tabController.animateTo(0);

    final sitesNotifier = Provider.of<SitesNotifier>(context, listen: false);
    sitesNotifier.currentSite = site;
  }
}
