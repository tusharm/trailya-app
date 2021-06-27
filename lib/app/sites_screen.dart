import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/model/sites_notifier.dart';

class SitesScreen extends StatelessWidget {
  SitesScreen({required this.sitesNotifier});

  static DateFormat dateFormat = DateFormat('MMM dd, yyyy hh:mm a');

  final SitesNotifier sitesNotifier;

  @override
  Widget build(BuildContext context) {
    return _buildListView(sitesNotifier.sites);
  }

  ListView _buildListView(List<Site> sites) {
    return ListView.separated(
      itemCount: sites.length + 2,
      separatorBuilder: (context, index) => Divider(
        height: 5.0,
        thickness: 0.5,
      ),
      itemBuilder: (context, index) {
        // two show dividers before the first and after the last item in the list
        if (index == 0 || index == sites.length + 1) {
          return Container();
        }

        final site = sites[index - 1];
        final postcodeText = site.postcode != null ? ', ${site.postcode}' : '';

        return ListTile(
          leading: Text('$index'),
          minLeadingWidth: 10,
          isThreeLine: true,
          dense: false,
          title: Text(site.title),
          subtitle: Text(
            '${site.address}, ${site.state}$postcodeText\n'
            '${dateFormat.format(site.exposureStartTime)} - ${dateFormat.format(site.exposureEndTime)}',
          ),
          onTap: () {
            final tabController = DefaultTabController.of(context)!;
            tabController.animateTo(0);

            sitesNotifier.setCurrentIndex(index - 1);
          },
        );
      },
    );
  }
}
