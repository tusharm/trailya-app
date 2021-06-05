import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';

import 'visit.dart';

///
/// Tracks current location and provides a stream of locations where
/// the user spent long enough time
///
class LocationTracker {
  static const int TRACKING_RADIUS_MTS = 2;
  static const int TRACKING_TIME_INTERVAL_MS = 10000;
  static const double TRACKING_DISTANCE_INTERVAL_MTS = 10;

  static const String ALLOWED_PLACE_TYPES = 'establishment';

  static LocationTracker? _instance;

  final location = Location();

  LocationTracker._internal() {
    _instance = this;
  }

  factory LocationTracker() => _instance ?? LocationTracker._internal();

  Future<bool> initialize() async {
    final enabled = await location.requestService();
    if (!enabled) return false;

    final PermissionStatus status = await location.requestPermission();
    final userPermitted = status == PermissionStatus.granted;
    if (userPermitted) {
      location.changeSettings(
        interval: TRACKING_TIME_INTERVAL_MS,
        distanceFilter: TRACKING_DISTANCE_INTERVAL_MTS,
      );
    }

    return userPermitted;
  }

  Future<LocationData> currentLocation() {
    return location.getLocation();
  }

  Stream<Visit> visits() {
    Visit? lastVisited;

    return location.onLocationChanged
        .map((LocationData loc) {
          final currentVisit = Visit(loc);
          // print('New visit: $currentVisit');

          if ((lastVisited == null) ||
              !currentVisit.longEnoughSince(lastVisited!)) {
            print(
                'First visit or last visit wasn\'t long enough, start tracking current visit');
            lastVisited = currentVisit;
            return null;
          }

          print('Record last visit and start tracking current visit: $currentVisit');

          lastVisited!.end();
          final last = lastVisited;
          lastVisited = currentVisit;
          return last;
        })
        .where((e) => e != null)
        .cast();
  }
}
