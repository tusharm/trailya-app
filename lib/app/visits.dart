import 'package:amilinked/app/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  final location = Location();
  late final bool locationPermitted;
  late List<LocationData> locations;

  @override
  void initState() {
    super.initState();
    initLocation().then((allowed) {
      setState(() {
        locations = List.empty(growable: true);
        locationPermitted = allowed;

        if (locationPermitted) {
          location.changeSettings(interval: 10000, distanceFilter: 1);
          location.enableBackgroundMode(enable: true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!locationPermitted) {
      return EmptyContent(
        title: 'Location tracking disabled',
        message: 'Manually add places you visited.',
      );
    }

    return StreamBuilder(
      stream: location.onLocationChanged,
      builder: (context, AsyncSnapshot<LocationData> snapshot) {
        if (snapshot.hasData) {
          locations.add(snapshot.data!);

          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              LocationData loc = locations.elementAt(index);

              final displacement = (index == 0) ? 0.0 : Geolocator
                  .distanceBetween(loc.latitude!, loc.longitude!, locations
                  .elementAt(index - 1)
                  .latitude!, locations
                  .elementAt(index - 1)
                  .longitude!).roundToDouble();

              return ListTile(
                leading: Text('${index + 1}'),
                title: Text('lat: ${loc.latitude}, long: ${loc.longitude}'),
                subtitle: Text(
                    'moved ${displacement} m, ${DateTime.fromMillisecondsSinceEpoch(
                        loc.time!.toInt())}'),
              );
            },
          );
        }

        return EmptyContent(title: 'Waiting for locations..', message: '');
      },
    );
  }

  Future<bool> initLocation() async {
    final enabled = await location.requestService();
    if (!enabled) return false;

    final PermissionStatus status = await location.requestPermission();
    return status == PermissionStatus.granted;
  }
}
