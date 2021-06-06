import 'package:location/location.dart';

import 'visit.dart';

///
/// Tracks current location and provides a stream of locations where
/// the user spent long enough time
///
class LocationTracker {
  LocationTracker._internal() {
    _instance = this;
  }

  factory LocationTracker() => _instance ?? LocationTracker._internal();

  static const int trackingRadiusMts = 2;
  static const int trackingTimeIntervalMs = 10000;
  static const double trackingDistanceIntervalMs = 10;

  static LocationTracker? _instance;
  final location = Location();

  Future<bool> initialize() async {
    final enabled = await location.requestService();
    if (!enabled) return false;

    final status = await location.requestPermission();
    final userPermitted = status == PermissionStatus.granted;
    if (userPermitted) {
      await location.changeSettings(
        interval: trackingTimeIntervalMs,
        distanceFilter: trackingDistanceIntervalMs,
      );

      await location.enableBackgroundMode(enable: true);
    }

    return userPermitted;
  }

  Stream<LocationData> locations() {
    return location.onLocationChanged;
  }

  Stream<Visit> visits() {
    Visit? lastVisited;

    return location.onLocationChanged
        .map((LocationData loc) {
          final currentVisit = Visit(loc);

          if ((lastVisited == null) ||
              !currentVisit.longEnoughSince(lastVisited!)) {
            lastVisited = currentVisit;
            return null;
          }

          lastVisited!.end();
          final last = lastVisited;
          lastVisited = currentVisit;
          return last;
        })
        .where((e) => e != null)
        .cast();
  }
}
