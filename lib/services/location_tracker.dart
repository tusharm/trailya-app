import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_place/google_place.dart' as places;
import 'package:location/location.dart';

///
/// Singleton to track current location and provides a stream of places visited;
/// uses a cache to reduce n/w calls to Google Places API
///
class LocationTracker {
  static const int TRACKING_TIME_INTERVAL_MS = 10000;
  static const double TRACKING_DISTANCE_INTERVAL_MTS = 10;
  static const int TRACKING_RADIUS_MTS = 2;
  static const String ALLOWED_PLACE_TYPES = 'establishment';

  static LocationTracker? _instance;

  final location = Location();
  late places.GooglePlace googlePlace;

  LocationTracker._internal() {
    googlePlace = places.GooglePlace(dotenv.env['PLACES_API_KEY']!);
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

  Stream<NearbyPlaces> visits() {
    return location.onLocationChanged.asyncMap((LocationData loc) async {
      places.NearBySearchResponse? resp =
          await googlePlace.search.getNearBySearch(
        places.Location(lat: loc.latitude, lng: loc.longitude),
        TRACKING_RADIUS_MTS,
      );

      final nearby = resp?.results
          ?.where((e) => e.types!.contains(ALLOWED_PLACE_TYPES))
          .toList();

      return NearbyPlaces(loc, nearby ?? Iterable.empty());
    });
  }
}

class NearbyPlaces {
  final LocationData loc;
  final Iterable<places.SearchResult> nearby;

  NearbyPlaces(this.loc, this.nearby);
}
