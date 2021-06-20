import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/widgets/center.dart';
import 'package:trailya/app/widgets/waiting.dart';
import 'package:trailya/services/store/site.dart';
import 'package:trailya/services/store/sites_store.dart';

class ExposedSitesPage extends StatelessWidget {
  final sitesStore = SitesStore();
  final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');

  static Widget create(BuildContext context) {
    return Provider<SitesStore>(
      create: (_) => SitesStore(),
      child: ExposedSitesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sitesStore = Provider.of<SitesStore>(context, listen: false);

    return StreamBuilder<List<Site>>(
      stream: sitesStore.getSites(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CenteredContent(
            title: 'Error getting sites',
            message: snapshot.error.toString(),
          );
        }

        if (snapshot.hasData) {
          return _buildListView(snapshot.data!);
        }

        return Waiting();
      },
    );
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
        return ListTile(
          leading: Text('$index'),
          minLeadingWidth: 10,
          isThreeLine: true,
          dense: false,
          title: Text(site.title),
          subtitle: Text(
            '${site.address}, ${site.state}, ${site.postcode}\n'
            '${dateFormat.format(site.exposureStartTime)} - ${dateFormat.format(site.exposureEndTime)}',
          ),
          onTap: () {},
        );
      },
    );
  }
}
