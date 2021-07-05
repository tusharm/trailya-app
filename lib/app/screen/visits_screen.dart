import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/widgets/dialog.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/services/location_service.dart';
import 'package:trailya/utils/assets.dart';
import 'package:trailya/utils/date_util.dart';

class VisitsScreen extends StatefulWidget {
  VisitsScreen({required this.sitesNotifier, required this.locationNotifier});

  static Widget create(SitesNotifier sitesNotifier) {
    return Consumer<LocationNotifier>(
      builder: (context, locationNotifier, _) => VisitsScreen(
        sitesNotifier: sitesNotifier,
        locationNotifier: locationNotifier,
      ),
    );
  }

  final SitesNotifier sitesNotifier;
  final LocationNotifier locationNotifier;

  LatLng asLatLng(LocationData locationData) {
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  @override
  _VisitsScreenState createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  final LocationData initialLocation = LocationData.fromMap({
    'latitude': -33.87241362319646,
    'longitude': 151.20726191291067,
  });

  final Completer<GoogleMapController> _mapController = Completer();
  DateTime? selectedExposureDate;
  List<DateTime> sortedExposureStartTimes = List.empty();

  @override
  Widget build(BuildContext context) {
    final currentSite = widget.sitesNotifier.currentSite;

    sortedExposureStartTimes =
        widget.sitesNotifier.sites.map((e) => e.exposureStartTime).toList();
    sortedExposureStartTimes.sort();

    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) => _mapController.complete(controller),
        initialCameraPosition: CameraPosition(
          target: currentSite == null
              ? widget.asLatLng(initialLocation)
              : LatLng(currentSite.latitude!, currentSite.longitude!),
          zoom: 17.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        circles: _getVisitAreas(),
        markers: _getSiteMarkers(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFabPressed,
        label: Text('Filter'),
        backgroundColor: Colors.indigo,
        hoverColor: Colors.indigoAccent,
        icon: Icon(Icons.calendar_today_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Set<Marker> _getSiteMarkers() {
    final sites = widget.sitesNotifier.sites
        .where((site) => _withinFilterWindow(site.exposureStartTime))
        .map((site) => Marker(
              markerId: MarkerId(site.uniqueId),
              icon: Assets.redMarkerIcon!,
              position: LatLng(site.latitude!, site.longitude!),
              infoWindow: InfoWindow(
                  title: site.title,
                  snippet:
                      '${formatDate(site.exposureStartTime)} - ${formatDate(site.exposureEndTime)}\nUpdated at ${formatDate(site.addedTime)}',
                  onTap: () {
                    showSiteDialog(context: context, site: site);
                  }),
            ))
        .toSet();

    final visits = widget.locationNotifier.visits
        .where((visit) => _withinFilterWindow(visit.start))
        .map((visit) => Marker(
              markerId: MarkerId(visit.uniqueId),
              icon: Assets.blueMarkerIcon!,
              position: widget.asLatLng(visit.loc),
              infoWindow: InfoWindow(
                  title: 'Visit',
                  snippet:
                      '${formatDate(visit.start)} - ${formatDate(visit.end)}',
                  onTap: () {}),
            ));

    sites.addAll(visits);
    return sites;
  }

  Set<Circle> _getVisitAreas() => widget.locationNotifier.visits.map((visit) {
        return Circle(
            circleId: CircleId(visit.uniqueId),
            fillColor: Colors.lightBlueAccent.withOpacity(0.2),
            strokeWidth: 2,
            strokeColor: Colors.lightBlue,
            center: widget.asLatLng(visit.loc),
            radius: LocationService.trackingDistanceIntervalMtr,
            consumeTapEvents: true,
            onTap: () {});
      }).toSet();

  void _onFabPressed() async {
    final date = await showDatePicker(
        context: context,
        helpText: 'Select exposure date',
        cancelText: 'Clear',
        confirmText: 'Apply',
        initialDate: selectedExposureDate ?? sortedExposureStartTimes.last,
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now(),
        selectableDayPredicate: (datetime) =>
            sortedExposureStartTimes.contains(datetime));

    setState(() {
      selectedExposureDate = date;
    });
  }

  bool _withinFilterWindow(DateTime datetime) {
    if (selectedExposureDate == null) return true;

    return datetime.isAfter(selectedExposureDate!) &&
        datetime.isBefore(selectedExposureDate!.add(Duration(days: 1)));
  }
}
