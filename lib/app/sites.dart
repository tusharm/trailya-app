import 'package:flutter/material.dart';
import 'package:trailya/app/widgets/center.dart';
import 'package:trailya/services/store/site.dart';
import 'package:trailya/services/store/sites_store.dart';

class ExposedSitesPage extends StatelessWidget {
  ExposedSitesPage({Key? key}) : super(key: key);
  final sitesStore = SitesStore();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Site>>(
      stream: sitesStore.getSites(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CenteredContent(
            title: 'Internal error',
            message: 'Got error getting sites: ${snapshot.error}',
          );
        }

        if (snapshot.hasData) {
          final sites = snapshot.data!;

          if (sites.isEmpty) {
            return CenteredContent(
              title: 'Nothing here',
              message: 'No sites found',
            );
          }

          return _buildListView(sites);
        }

        return CircularProgressIndicator();
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
          isThreeLine: true,
          dense: false,
          title: Text(site.name),
          subtitle: Text(
            '${site.address}, ${site.state}, ${site.postcode}\n'
            '${site.exposureDate}, ${site.exposureStartTime} - ${site.exposureEndTime}',
          ),
          onTap: () {},
        );
      },
    );
  }
}
