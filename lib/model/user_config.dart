import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  Location._(
      {required this.state, required this.latlng, required this.zoomLevel});

  static Location NSW = Location._(
    state: 'NSW',
    latlng: LatLng(-33.8568, 151.2153),
    zoomLevel: 5.5,
  );

  static Location VIC = Location._(
    state: 'VIC',
    latlng: LatLng(-37.4147955041648, 144.90421805530787),
    zoomLevel: 6.0,
  );

  final String state;
  final LatLng latlng;
  final double zoomLevel;

  @override
  String toString() {
    return state;
  }
}

class UserConfig extends ChangeNotifier {
  bool _crashReportEnabled = !kDebugMode;
  bool _trackingEnabled = false;
  Location _location = Location.NSW;

  Location get location => _location;

  bool get trackingEnabled => _trackingEnabled;

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

  set trackingEnabled(bool enabled) {
    _trackingEnabled = enabled;
    notifyListeners();
  }
}
