import 'package:flutter/material.dart';
import 'package:trailya/services/store/db_helper.dart';
import 'package:trailya/services/store/site.dart';

class ExposedSitesPage extends StatelessWidget {
  const ExposedSitesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DataBaseHelper().sites(),
        builder: (BuildContext context, AsyncSnapshot<List<Site>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Got error getting sites: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            final items = snapshot.data;

            return ListView.builder(
              itemCount: items?.length,
              itemBuilder: (context, index) {
                final site = items?.elementAt(index);

                return ListTile(
                  leading: Icon(Icons.place),
                  title: Text(site!.name),
                  subtitle:
                      Text('${site.address}, ${site.state}, ${site.postcode}'),
                );
              },
            );
          }

          return CircularProgressIndicator();
        });
  }
}
