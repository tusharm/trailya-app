import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_place/google_place.dart' as places;
import 'package:location/location.dart';

import 'widgets/empty.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  final location = Location();
  late places.GooglePlace googlePlace;

  late final bool locationPermitted;
  late List<LocationWithPlaces> locations;

  @override
  void initState() {
    googlePlace = places.GooglePlace(dotenv.env['PLACES_API_KEY']!);

    initLocation().then((allowed) {
      setState(() {
        locations = List.empty(growable: true);
        locationPermitted = allowed;

        if (locationPermitted) {
          location.changeSettings(interval: 10000, distanceFilter: 1);
          // location.enableBackgroundMode(enable: true);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!locationPermitted) {
      return EmptyContent(
        title: 'Location tracking disabled',
        message: 'Manually add places you visited.',
      );
    }

    Stream<LocationWithPlaces> placesStream =
        location.onLocationChanged.asyncMap((loc) async {
      return await locationWithPlaces(loc);
    });

    return StreamBuilder(
      stream: placesStream,
      builder: (context, AsyncSnapshot<LocationWithPlaces> snapshot) {
        if (snapshot.hasData) {
          locations.add(snapshot.data!);

          return ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              LocationWithPlaces loc = locations.elementAt(index);

              return ListTile(
                leading: Text('${index + 1}'),
                title: Text(
                    'lat: ${loc.loc.latitude}, long: ${loc.loc.longitude}'),
                subtitle:
                    Text('${loc.nearbyPlaces.map((e) => e.name).join(",")}'),
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

  Future<LocationWithPlaces> locationWithPlaces(LocationData loc) async {
    places.NearBySearchResponse? results =
        await googlePlace.search.getNearBySearch(
      places.Location(lat: loc.latitude, lng: loc.longitude),
      10,
    );

    return new LocationWithPlaces(
      loc: loc,
      nearbyPlaces: results == null ? List.empty() : results.results!,
    );
  }
}

class LocationWithPlaces {
  final LocationData loc;
  final List<places.SearchResult> nearbyPlaces;

  LocationWithPlaces({
    required this.loc,
    required this.nearbyPlaces,
  });
}
