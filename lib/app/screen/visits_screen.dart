import 'dart:async';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/widgets/dialog.dart';
import 'package:trailya/app/widgets/fab/clear_filter_fab.dart';
import 'package:trailya/app/widgets/fab/exposure_date_filter_fab.dart';
import 'package:trailya/app/widgets/fab/sites_filter_fab.dart';
import 'package:trailya/app/widgets/fab/visits_filter_fab.dart';
import 'package:trailya/model/filters.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/model/user_config.dart';
import 'package:trailya/model/visit.dart';
import 'package:trailya/utils/assets.dart';
import 'package:trailya/utils/date_util.dart';

class VisitsScreen extends StatefulWidget {
  @override
  _VisitsScreenState createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    final currentUserConfig = Provider.of<UserConfig>(context);
    final sitesNotifier = Provider.of<SitesNotifier>(context);
    final locationNotifier = Provider.of<LocationNotifier>(context);
    final filters = Provider.of<Filters>(context);

    final filteredSites = filters.showVisitsOnly
        ? List<Site>.empty()
        : sitesNotifier.sites
            .where((s) => filters.withinExposureDate(s))
            .where((s) => filters.filterSuburb(s))
            .toList();

    final filteredVisits = locationNotifier.visits
        .where((v) => filters.withinExposureDate(v))
        .toList();

    final markers = _getSiteMarkers(filteredSites, filteredVisits);
    final currentSite = sitesNotifier.currentSite;

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
        markers: markers,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: AnimatedFloatingActionButton(
        fabButtons: [
          ClearFilterFAB(
            locationNotifier: locationNotifier,
            sitesNotifier: sitesNotifier,
            filters: filters,
          ),
          ExposureDateFilterFAB(
            locationNotifier: locationNotifier,
            sitesNotifier: sitesNotifier,
            filters: filters,
          ),
          VisitFilterFAB(
            locationNotifier: locationNotifier,
            filters: filters,
          ),
          SitesFilterFAB(
            sitesNotifier: sitesNotifier,
            filters: filters,
          ),
        ],
        colorStartAnimation: Colors.indigo,
        colorEndAnimation: Colors.indigo,
        animatedIconData: AnimatedIcons.search_ellipsis,
      ),
    );
  }

  Set<Marker> _getSiteMarkers(List<Site> sites, List<Visit> visits) {
    final filteredSites = sites
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
                  onTap: () => showSiteDialog(context: context, site: site)),
            ))
        .toSet();

    final filteredVisits = visits.map(
      (visit) => Marker(
        zIndex: 1.0,
        markerId: MarkerId(visit.id),
        icon:
            visit.exposed ? Assets.orangeMarkerIcon! : Assets.greenMarkerIcon!,
        position: LatLng(visit.loc.latitude!, visit.loc.longitude!),
        infoWindow: InfoWindow(
            title:
                'You were here ${visit.exposed ? '(possibly exposed!)' : ''}',
            snippet: '${formatDate(visit.start)} - ${formatDate(visit.end)}',
            onTap: () => showVisitDialog(context: context, visit: visit)),
      ),
    );

    return filteredSites.followedBy(filteredVisits).toSet();
  }
}
