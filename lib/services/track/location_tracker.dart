import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_place/google_place.dart' as gp;
import 'package:location/location.dart';

import 'visit.dart';

///
/// Singleton to track current location and provides a stream of places visited;
/// uses a cache to reduce n/w calls to Google Places API
///
class LocationTracker {
  static const int TRACKING_RADIUS_MTS = 2;
  static const int TRACKING_TIME_INTERVAL_MS = 30000;
  static const int TRACKING_MIN_STAY_MS = 60000;
  static const double TRACKING_DISTANCE_INTERVAL_MTS = 5;

  static const String ALLOWED_PLACE_TYPES = 'establishment';

  static LocationTracker? _instance;

  final location = Location();
  late gp.GooglePlace googlePlace;

  LocationTracker._internal() {
    googlePlace = gp.GooglePlace(dotenv.env['PLACES_API_KEY']!);
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

  Stream<Visit> visits() {
    Visit? lastVisited;

    return location.onLocationChanged
        .asyncMap((LocationData loc) async {
          // to filter out multiple notifications for the same location
          if (lastVisited?.loc == loc) return null;

          gp.NearBySearchResponse? resp =
              await googlePlace.search.getNearBySearch(
            gp.Location(lat: loc.latitude, lng: loc.longitude),
            TRACKING_RADIUS_MTS,
          );

          // find the first match
          final places = resp!.results!
              .where((e) => e.types!.contains(ALLOWED_PLACE_TYPES))
              .toList();

          if (places.isEmpty) return null;

          final current = Visit(loc, places.first);

          if (lastVisited == null) {
            lastVisited = current;
            return null;
          }

          // location changed too quickly or still at the older location
          if (intervalMs(current, lastVisited!) < TRACKING_MIN_STAY_MS ||
              current.samePlaceId(lastVisited!)) {
            return null;
          }

          final last = lastVisited;
          last!.end();

          lastVisited = current;
          return last;
        })
        .where((event) => event != null)
        .cast();
  }

  int intervalMs(Visit current, Visit lastVisited) {
    DateTime asDateTime(double millisSinceEpoch) =>
        DateTime.fromMillisecondsSinceEpoch(millisSinceEpoch.toInt());

    final delta = asDateTime(current.startTime)
        .difference(asDateTime(lastVisited.startTime));
    return delta.inMilliseconds;
  }
}
