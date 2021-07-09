import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/widgets/dialog.dart';
import 'package:trailya/model/config.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/sites_notifier.dart';
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
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    final currentUserConfig = Provider.of<UserConfig>(context, listen: false);
    final currentSite = widget.sitesNotifier.currentSite;

    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) => _mapController.complete(controller),
        initialCameraPosition: CameraPosition(
          target: currentSite == null
              ? currentUserConfig.location.latlng
              : LatLng(currentSite.latitude!, currentSite.longitude!),
          zoom: currentSite == null ? 10.0 : 17.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _getSiteMarkers(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFabPressed,
        label: Text('By exposure date'),
        backgroundColor: Colors.indigo,
        hoverColor: Colors.indigoAccent,
        icon: Icon(Icons.filter_alt_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Set<Marker> _getSiteMarkers() {
    final sites = widget.sitesNotifier.filteredSites
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
                  title: 'You were here',
                  snippet:
                      '${formatDate(visit.start)} - ${formatDate(visit.end)}',
                  onTap: () {}),
            ));

    sites.addAll(visits);
    return sites;
  }

  void _onFabPressed() async {
    final sortedExposureStartTimes =
        widget.sitesNotifier.sites.map((e) => e.exposureStartTime).toList();
    sortedExposureStartTimes.sort();

    final date = await showDatePicker(
        context: context,
        helpText: 'Select exposure date',
        cancelText: 'Clear',
        confirmText: 'Apply',
        initialDate: widget.sitesNotifier.selectedExposureDate ??
            sortedExposureStartTimes.last,
        firstDate: DateTime.now().subtract(Duration(days: 30)),
        lastDate: DateTime.now(),
        selectableDayPredicate: (datetime) =>
            !datetime.isBefore(sortedExposureStartTimes.first) &&
            !datetime.isAfter(sortedExposureStartTimes.last));

    widget.sitesNotifier.selectedExposureDate = date;
  }

  bool _withinFilterWindow(DateTime datetime) {
    final selectedDate = widget.sitesNotifier.selectedExposureDate;
    if (selectedDate == null) return true;

    return datetime.isAfter(selectedDate) &&
        datetime.isBefore(selectedDate.add(Duration(days: 1)));
  }
}
