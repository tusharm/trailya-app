import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trailya/model/visit.dart';
import 'package:trailya/services/location_service.dart';
import 'package:trailya/services/visits_store.dart';

class LocationNotifier extends ChangeNotifier {
  LocationNotifier({required this.locationService, required this.visitsStore}) {
    streamSubscription = locationService.visits().listen(_recordVisit);

    visitsStore.visits().then((List<Visit> existingVisits) {
      _visits.addAll(existingVisits);
      notifyListeners();
    });
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

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }
}
