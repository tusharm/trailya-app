import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:trailya/model/visit.dart';
import 'package:trailya/services/location_service.dart';

class LocationNotifier extends ChangeNotifier {
  LocationNotifier({required this.locationService}) {
    _visits.addAll(_makeDummyList());
    locationService.visits().listen(_recordVisit);
  }

  final LocationService locationService;
  final List<Visit> _visits = List.empty(growable: true);

  List<Visit> get visits => _visits;

  void _recordVisit(visit) {
    _visits.add(visit);
    notifyListeners();
  }

  List<Visit> _makeDummyList() {
    var visits = [
      Visit(LocationData.fromMap({
        'latitude': -33.8659,
        'longitude': 151.2150,
        'time': DateTime.now()
            .subtract(Duration(hours: 2))
            .toUtc()
            .millisecondsSinceEpoch
            .toDouble()
      })),
      Visit(LocationData.fromMap({
        'latitude': -33.8712,
        'longitude': 151.2133,
        'time': DateTime.now()
            .subtract(Duration(hours: 4))
            .toUtc()
            .millisecondsSinceEpoch
            .toDouble()
      })),
      Visit(LocationData.fromMap({
        'latitude': 33.8732,
        'longitude': 151.2071,
        'time': DateTime.now()
            .subtract(Duration(hours: 8))
            .toUtc()
            .millisecondsSinceEpoch
            .toDouble()
      })),
      Visit(LocationData.fromMap({
        'latitude': -33.8696,
        'longitude': 151.2021,
        'time': DateTime.now()
            .subtract(Duration(days: 1))
            .toUtc()
            .millisecondsSinceEpoch
            .toDouble()
      })),
    ];

    visits.forEach((visit) {
      visit.finish();
    });

    return visits;
  }
}
