import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trailya/services/track/location_tracker.dart';
import 'package:trailya/services/track/visit.dart';

import 'widgets/empty.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  final LocationTracker tracker = LocationTracker();

  late final List<Visit> locations = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tracker.initialize(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData || !snapshot.data!) {
          return EmptyContent(
            title: 'Location tracking disabled',
            message: 'Manually add visited places',
          );
        }

        return StreamBuilder(
          stream: tracker.visits(),
          builder: (context, AsyncSnapshot<Visit?> snapshot) {
            if (!snapshot.hasData) {
              return EmptyContent(
                title: 'Waiting for locations..',
                message: '',
              );
            }

            locations.add(snapshot.data!);
            return _buildContent();
          },
        );
      },
    );
  }

  ListView _buildContent() {
    return ListView.builder(
      itemCount: locations.length,
      itemBuilder: (context, index) {
        Visit nearBy = locations.elementAt(index);

        return ListTile(
          isThreeLine: true,
          title: Text(nearBy.nearby.name ?? 'Unknown'),
          subtitle: Text('${nearBy.nearby.vicinity ?? 'Unknown'}\n'
              '${asDateTime(nearBy.startTime)} - ${asDateTime(nearBy.endTime!)}'),
        );
      },
    );
  }

  String asDateTime(double millisSinceEpoch) => DateFormat.yMd()
      .add_jms()
      .format(DateTime.fromMillisecondsSinceEpoch(millisSinceEpoch.toInt()));
}
