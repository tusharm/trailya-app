import 'package:location/location.dart';
import 'package:trailya/model/visit.dart';

///
/// Tracks current location and provides a stream of locations where
/// the user spent long enough time
///
class LocationService {
  LocationService._({
    this.enabled,
    required this.location,
  });

  static const int trackingTimeIntervalMs = 1000;
  static const double trackingDistanceIntervalMtr = 10;
  static LocationService? instance;

  final Location location;
  final enabled;

  static Future<LocationService> create() async {
    final location = Location();

    final enabled = await location.requestService();
    if (enabled) {
      final status = await location.requestPermission();
      if (status == PermissionStatus.granted) {
        await location.changeSettings(
          accuracy: LocationAccuracy.high,
          interval: trackingTimeIntervalMs,
          distanceFilter: trackingDistanceIntervalMtr,
        );

        return LocationService._(
          enabled: true,
          location: location,
        );
      }
    }

    return LocationService._(
      enabled: false,
      location: location,
    );
  }

  Stream<LocationData> locations() {
    return enabled ? location.onLocationChanged : Stream.empty();
  }

  Stream<Visit> visits() {
    if (!enabled) {
      return Stream.empty();
    }

    Visit? lastVisited;

    return location.onLocationChanged
        .map((LocationData loc) {
          final currentVisit = Visit(loc);

          if ((lastVisited == null) ||
              !currentVisit.longEnoughSince(lastVisited!)) {
            lastVisited = currentVisit;
            return null;
          }

          lastVisited!.finish();
          final last = lastVisited;
          lastVisited = currentVisit;
          return last;
        })
        .where((e) => e != null)
        .cast();
  }
}
