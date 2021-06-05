import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  late final List<Visit> visits = List.empty(growable: true);
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initTracker(),
      builder: (context, AsyncSnapshot<LocationData?> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return EmptyContent(
            title: 'Location tracking disabled',
            message: 'Manually add visited places',
          );
        }

        final currentLocation = _toLatLng(snapshot.data!);

        return StreamBuilder<Visit>(
          stream: tracker.visits(),
          builder: (context, AsyncSnapshot<Visit> snapshot) {
            final latLng = snapshot.hasData
                ? _toLatLng(snapshot.data!.loc)
                : currentLocation;

            return FutureBuilder<GoogleMap>(
              future: _buildMap(latLng),
              builder: (context, AsyncSnapshot<GoogleMap> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                }

                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  LatLng _toLatLng(LocationData locationData) {
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  Future<GoogleMap> _buildMap(LatLng location) async {
    final map = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: location,
        zoom: 17.0,
      ),
      myLocationEnabled: true,
    );

    if (_mapController != null) {
      await _mapController!.animateCamera(CameraUpdate.newLatLng(location));
    }

    return map;
  }

  Future<LocationData?> _initTracker() async {
    final success = await tracker.initialize();
    return success ? await tracker.currentLocation() : null;
  }

  void _onMapCreated(GoogleMapController controller) {
    this._mapController = controller;
  }
}
