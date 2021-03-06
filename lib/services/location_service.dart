import 'package:location/location.dart';
import 'package:trailya/model/user_config.dart';
import 'package:trailya/model/visit.dart';
import 'package:trailya/utils/date_util.dart';

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
  static const int visitIntervalThresholdMs = 60 * 1000;
  static const double trackingDistanceIntervalMtr = 5;
  static LocationService? instance;

  final Location location;
  final enabled;

  static Future<LocationService> create(bool bgLocationEnabled) async {
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

        await location.enableBackgroundMode(enable: bgLocationEnabled);

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

    LocationData? lastLoc;

    return location.onLocationChanged
        .map((LocationData loc) {
          final currentLoc = loc;

          if (lastLoc == null || !enoughTimeBetween(currentLoc, lastLoc!)) {
            lastLoc = currentLoc;
            return null;
          }

          final visit = Visit(
            loc: lastLoc!,
            start: asDateTime(lastLoc!.time!.toInt()),
            end: asDateTime(currentLoc.time!.toInt()),
          );
          lastLoc = currentLoc;
          return visit;
        })
        .where((e) => e != null)
        .cast();
  }

  bool enoughTimeBetween(LocationData a, LocationData b) {
    final aTime = asDateTime(a.time!.toInt());
    final bTime = asDateTime(b.time!.toInt());
    return aTime.difference(bTime).inMilliseconds > visitIntervalThresholdMs;
  }

  Future<void> update(UserConfig userConfig) async {
    final bgEnabled = await location.isBackgroundModeEnabled();
    if (bgEnabled != userConfig.bgLocationEnabled) {
      await location.enableBackgroundMode(enable: userConfig.bgLocationEnabled);
    }
  }

  Future<void> dispose() async {
    final bgEnabled = await location.isBackgroundModeEnabled();
    if (bgEnabled) {
      await location.enableBackgroundMode(enable: false);
    }
  }
}
