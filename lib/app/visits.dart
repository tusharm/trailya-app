import 'package:flutter/material.dart';
import 'package:trailya/services/location_tracker.dart';

import 'widgets/empty.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  final LocationTracker tracker = LocationTracker();

  late final bool locationPermitted;
  late final List<NearbyPlaces> locations = List.empty(growable: true);

  @override
  void initState() {
    tracker.initialize().then((allowed) {
      setState(() {
        locationPermitted = allowed;
      });
    });
    super.initState();
  }

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
          builder: (context, AsyncSnapshot<NearbyPlaces> snapshot) {
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
        NearbyPlaces vic = locations.elementAt(index);

        return ListTile(
          leading: Text('${index + 1}'),
          isThreeLine: true,
          title: Text('lat/lng: ${vic.loc.latitude},${vic.loc.longitude} at '),
          subtitle: Text(
              '${vic.nearby.map((e) => e.name).join(",")}  at ${DateTime.fromMillisecondsSinceEpoch(vic.loc.time!.toInt()).toIso8601String()}'),
        );
      },
    );
  }
}
