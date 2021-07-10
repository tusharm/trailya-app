import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// enum Location { NSW, VIC }
//
// extension LocationExtensions on Location {
//   String asString() {
//     return toString().split('.').last;
//   }
// }

class Location {
  Location._({required this.state, required this.latlng});

  static Location NSW = Location._(
    state: 'NSW',
    latlng: LatLng(-33.854768486192846, 151.21604587606268), // Opera House
  );

  static Location VIC = Location._(
    state: 'VIC',
    latlng: LatLng(-37.81790384139683, 144.96908283518505), // Fed Square
  );

  final String state;
  final LatLng latlng;

  String toString() {
    return state;
  }
}

class UserConfig extends ChangeNotifier {
  bool _crashReportEnabled = !kDebugMode;
  Location _location = Location.NSW;

  Location get location => _location;

  bool get crashReportEnabled => _crashReportEnabled;

  set location(loc) {
    _location = loc;
    notifyListeners();
  }

  set crashReportEnabled(bool enabled) {
    _crashReportEnabled = enabled;
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled);
    notifyListeners();
  }
}
