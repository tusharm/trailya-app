import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocation {
  UserLocation._(
      {required this.state, required this.latlng, required this.zoomLevel});

  static UserLocation NSW = UserLocation._(
    state: 'NSW',
    latlng: LatLng(-33.94567321973889, 146.90911933779716),
    zoomLevel: 5.5,
  );

  static UserLocation VIC = UserLocation._(
    state: 'VIC',
    latlng: LatLng(-37.30508110308386, 145.3751502558589),
    zoomLevel: 6.0,
  );

  final String state;
  final LatLng latlng;
  final double zoomLevel;

  @override
  String toString() {
    return state;
  }

  static UserLocation fromString(String str) {
    if (NSW.state.compareTo(str) == 0) {
      return NSW;
    } else if (VIC.state.compareTo(str) == 0) {
      return VIC;
    } else {
      throw ArgumentError.value(
          str, 'Invalid argument to Location.fromString()');
    }
  }
}

