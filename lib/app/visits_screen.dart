import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:trailya/app/widgets/center.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/services/track/location_tracker.dart';
import 'package:trailya/services/track/visit.dart';

class VisitsScreen extends StatefulWidget {
  const VisitsScreen({
    required this.sitesNotifier,
  });

  final SitesNotifier sitesNotifier;

  @override
  _VisitsScreenState createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  final LocationTracker tracker = LocationTracker();
  GoogleMapController? _mapController;
  final BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;

  final markers = List.empty(growable: true);
  bool trackingPermitted = false;
  LocationData initialLocation = LocationData.fromMap(
      {'latitude': -33.87241362319646, 'longitude': 151.20726191291067});

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
      initialData: initialLocation,
      builder: (ctxt, snapshot) {
        initialLocation = snapshot.data!;
        var latLng = _toLatLng(initialLocation);

        if (_mapController != null) {
          _mapController!.animateCamera(CameraUpdate.newLatLng(
              widget.sitesNotifier.currentSite ?? latLng));
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
