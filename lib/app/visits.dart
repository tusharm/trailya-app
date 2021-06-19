import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:trailya/app/widgets/center.dart';
import 'package:trailya/services/track/location_tracker.dart';
import 'package:trailya/services/track/visit.dart';

import 'widgets/waiting.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  final LocationTracker tracker = LocationTracker();
  GoogleMapController? _mapController;
  final BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;

  final markers = List.empty(growable: true);
  bool trackingPermitted = false;

  @override
  void initState() {
    tracker.initialize().then((permitted) {
      setState(() {
        trackingPermitted = permitted;
        if (trackingPermitted) {
          tracker.visits().listen(_onVisit);
        }
      });
    });

    super.initState();
  }

  void _onVisit(Visit visit) {
    final latLng = _toLatLng(visit.loc);

    setState(() {
      markers.add(Marker(
        markerId: MarkerId('marker-${markers.length}'),
        icon: _markerIcon,
        position: latLng,
        infoWindow: InfoWindow(
          title: _humanisedDuration(visit),
          snippet: '${_format(visit.startTime)} - ${_format(visit.endTime!)}',
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!trackingPermitted) {
      return CenteredContent(
        title: 'Location tracking disabled',
        message: 'Enable it in Settings',
      );
    }

    return StreamBuilder<LocationData>(
      stream: tracker.locations(),
      builder: (ctxt, snapshot) {
        if (!snapshot.hasData) return Waiting();

        var latLng = _toLatLng(snapshot.data!);

        if (_mapController != null) {
          _mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
        }

        return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: latLng,
            zoom: 17.0,
          ),
          myLocationEnabled: true,
          markers: markers.toSet().cast(),
        );
      },
    );
  }

  String _humanisedDuration(Visit visit) {
    final duration = visit.duration();
    if (duration.inSeconds < 60) {
      return '${visit.duration().inSeconds} secs';
    } else if (duration.inMinutes < 60) {
      return '${visit.duration().inMinutes} mins';
    } else {
      return '${visit.duration().inHours} hrs';
    }
  }

  String _format(double msSinceEpoch) => DateFormat()
      .add_jms()
      .format(DateTime.fromMillisecondsSinceEpoch(msSinceEpoch.toInt()));

  LatLng _toLatLng(LocationData locationData) {
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }
}
