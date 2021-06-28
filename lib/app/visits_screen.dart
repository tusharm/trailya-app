import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/widgets/center.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/model/visit.dart';
import 'package:trailya/services/location_service.dart';

class VisitsScreen extends StatefulWidget {
  VisitsScreen({required this.sitesNotifier});

  final DateFormat format = DateFormat().add_jms();
  final BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final SitesNotifier sitesNotifier;

  Circle toCircle(String id, Visit visit) {
    return Circle(
        circleId: CircleId(id),
        fillColor: Colors.redAccent.withOpacity(0.2),
        strokeWidth: 2,
        strokeColor: Colors.redAccent,
        center: asLatLng(visit.loc),
        radius: LocationService.trackingDistanceIntervalMtr,
        consumeTapEvents: true,
        onTap: () {});
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
  final visits = List.empty(growable: true);
  final LocationData initialLocation = LocationData.fromMap({
    'latitude': -33.87241362319646,
    'longitude': 151.20726191291067,
  });

  final Completer<GoogleMapController> _mapController = Completer();

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
    final currentSite = widget.sitesNotifier.currentSite;
    return GoogleMap(
      onMapCreated: (controller) => _mapController.complete(controller),
      initialCameraPosition: CameraPosition(
        target: currentSite == null
            ? widget.asLatLng(initialLocation)
            : LatLng(currentSite.latitude!, currentSite.longitude!),
        zoom: 17.0,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      circles: visits.toSet().cast(),
      markers: _getSiteMarkers(),
    );
  }

  Set<Marker> _getSiteMarkers() {
    String formatted(DateTime date) =>
        widget.formatDate(date.millisecondsSinceEpoch.toDouble());

    return widget.sitesNotifier.sites
        .map((site) => Marker(
              markerId: MarkerId(site.uniqueId),
              icon: widget.markerIcon,
              position: LatLng(site.latitude!, site.longitude!),
              infoWindow: InfoWindow(
                title: site.title,
                snippet:
                    '${formatted(site.exposureStartTime)} - ${formatted(site.exposureEndTime)}\nUpdated at ${formatted(site.addedTime)}',
              ),
            ))
        .toSet();
  }

  void _recordVisit(visit) {
    setState(() {
      visits.add(widget.toCircle('visit-${visits.length}', visit));
    });
  }

  Future<void> _recenterMap(LocationData locationData) async {
    final latLng = widget.asLatLng(locationData);

    final controller = await _mapController.future;
    await controller.animateCamera(CameraUpdate.newLatLng(latLng));
  }
}
