import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/model/visit.dart';
import 'package:trailya/services/location_service.dart';
import 'package:trailya/services/visits_store.dart';

class LocationNotifier extends ChangeNotifier {
  LocationNotifier._({
    required this.locationService,
    required this.visitsStore,
  }) {
    streamSubscription = locationService.visits().listen(_recordVisit);

    visitsStore.all().then((List<Visit> existingVisits) {
      _visits.addAll(existingVisits);
      notifyListeners();
    });
  }

  static final exposureDistanceMts = 50;

  static SingleChildWidget create(VisitsStore visitsStore) {
    return Consumer<LocationService>(
      builder: (_, locationService, child) {
        return ChangeNotifierProxyProvider<SitesNotifier, LocationNotifier>(
          create: (_) => LocationNotifier._(
            visitsStore: visitsStore,
            locationService: locationService,
          ),
          update: (_, sitesNotifer, locNotifier) {
            locNotifier!._evaluateExposures(sitesNotifer.sites);
            return locNotifier;
          },
          child: child,
        );
      },
    );
  }

  late StreamSubscription<Visit> streamSubscription;
  final LocationService locationService;
  final VisitsStore visitsStore;

  final List<Visit> _visits = List.empty(growable: true);

  List<Visit> get visits => _visits;

  void _recordVisit(visit) {
    visitsStore.persist(visit).then((value) {
      _visits.add(visit);
      notifyListeners();
    });
  }

  Future<void> _evaluateExposures(List<Site> sites) async {

    // determines if a site and a visit overlap in time
    bool coincide(Visit v, Site s) => !(s.exposureStartTime.isAfter(v.end) ||
        s.exposureEndTime.isBefore(v.start));

    // determines geo distance between a site and a visit
    num distanceInMtr(Visit v, Site s) => SphericalUtil.computeDistanceBetween(
          LatLng(v.loc.latitude!, v.loc.longitude!),
          LatLng(s.latitude!, s.longitude!),
        );


    final exposedVisits = _visits
        .where((v) => !v.exposed).toList() // filter out all previously exposed visits
        .where(
      (visit) {
        // check each visit for exposure
        final exposureSites = sites
            .where((site) => coincide(visit, site))
            .where((site) =>
                distanceInMtr(visit, site).compareTo(exposureDistanceMts) < 0);

        if (exposureSites.isEmpty) {
          return false;
        }

        visit.exposed = true;
        return true;
      },
    );

    if (exposedVisits.isNotEmpty) {
      await visitsStore.persistAll(exposedVisits.toList());
      notifyListeners();
    }
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }
}
