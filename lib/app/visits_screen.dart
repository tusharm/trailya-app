import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/widgets/center.dart';
import 'package:trailya/model/visit.dart';
import 'package:trailya/services/location_service.dart';

class VisitsScreen extends StatefulWidget {
  final BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;

  final DateFormat format = DateFormat().add_jms();

  Marker toMarker(String id, Visit visit) {
    final latLng = asLatLng(visit.loc);

    return Marker(
      markerId: MarkerId(id),
      icon: _markerIcon,
      position: latLng,
      infoWindow: InfoWindow(
        title: readableDurationFor(visit),
        snippet:
            '${formatDate(visit.startTime)} - ${formatDate(visit.endTime!)}',
      ),
    );
  }

  String formatDate(double msSinceEpoch) {
    return format
        .format(DateTime.fromMillisecondsSinceEpoch(msSinceEpoch.toInt()));
  }

  LatLng asLatLng(LocationData locationData) {
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  String readableDurationFor(Visit visit) {
    final duration = visit.duration();
    if (duration.inSeconds < 60) {
      return '${visit.duration().inSeconds} secs';
    } else if (duration.inMinutes < 60) {
      return '${visit.duration().inMinutes} mins';
    } else {
      return '${visit.duration().inHours} hrs';
    }
  }

  @override
  _VisitsScreenState createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  final markers = List.empty(growable: true);
  final LocationData initialLocation = LocationData.fromMap({
    'latitude': -33.87241362319646,
    'longitude': 151.20726191291067,
  });

  GoogleMapController? _mapController;

  @override
  void initState() {
    final locationService =
        Provider.of<LocationService>(context, listen: false);

    locationService.visits().listen(_recordVisit);
    locationService.locations().listen(_recenterMap);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<LocationService>(context, listen: false).enabled) {
      return CenteredContent(
        title: 'Location tracking disabled',
        message: 'Enable it in Settings',
      );
    }

    return GoogleMap(
      onMapCreated: (controller) => _mapController = controller,
      initialCameraPosition: CameraPosition(
        target: widget.asLatLng(initialLocation),
        zoom: 17.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: markers.toSet().cast(),
    );
  }

  void _recordVisit(visit) {
    setState(() {
      markers.add(widget.toMarker('marker-${markers.length}', visit));
    });
  }

  void _recenterMap(LocationData locationData) {
    final latLng = widget.asLatLng(locationData);

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    }
  }

  @override
  void dispose() {
    if (_mapController != null) {
      _mapController!.dispose();
    }

    super.dispose();
  }
}
