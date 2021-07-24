import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/widgets/date_filter_fab.dart';
import 'package:trailya/app/widgets/dialog.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/model/user_config.dart';
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
              : LatLng(currentSite.lat!, currentSite.lng!),
          zoom:
              currentSite == null ? currentUserConfig.location.zoomLevel : 17.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _getSiteMarkers(),
      ),
      floatingActionButton: DateFilterFAB(
        sitesNotifier: widget.sitesNotifier,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Set<Marker> _getSiteMarkers() {
    final sites = widget.sitesNotifier.filteredSites
        .where((site) => (site.lat != null) && (site.lng != null))
        .map((site) => Marker(
              zIndex: 0.5,
              markerId: MarkerId(site.uniqueId),
              icon: Assets.redMarkerIcon!,
              position: LatLng(site.lat!, site.lng!),
              infoWindow: InfoWindow(
                  title: site.title,
                  snippet:
                      '${formatDate(site.start)} - ${formatDate(site.end)}\nUpdated at ${formatDate(site.addedTime)}',
                  onTap: () {
                    showSiteDialog(context: context, site: site);
                  }),
            ))
        .toSet();

    final visits = widget.locationNotifier.visits
        .where((visit) => _withinFilterWindow(visit.start))
        .map(
          (visit) => Marker(
            zIndex: 1.0,
            markerId: MarkerId(visit.id),
            icon: visit.exposed
                ? Assets.orangeMarkerIcon!
                : Assets.greenMarkerIcon!,
            position: widget.asLatLng(visit.loc),
            infoWindow: InfoWindow(
                title:
                    'You were here ${visit.exposed ? '(possibly exposed!)' : ''}',
                snippet:
                    '${formatDate(visit.start)} - ${formatDate(visit.end)}',
                onTap: () {
                  showVisitDialog(context: context, visit: visit);
                }),
          ),
        );

    sites.addAll(visits);
    return sites;
  }

  bool _withinFilterWindow(DateTime datetime) {
    final selectedDate = widget.sitesNotifier.selectedExposureDate;
    if (selectedDate == null) return true;

    return datetime.isAfter(selectedDate) &&
        datetime.isBefore(selectedDate.add(Duration(days: 1)));
  }
}
