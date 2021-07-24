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

  static Location fromString(String str) {
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

class UserConfig extends ChangeNotifier {
  UserConfig({
    required this.id,
  });

  final String id;
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

  Map<String, dynamic> toMap() => {
        'id': id,
        'enable_crash_report': _crashReportEnabled ? 1 : 0,
        'location': _location.state,
      };

  static UserConfig fromMap(Map<String, dynamic> data) {
    final userConfig = UserConfig(id: data['id'].toString());
    userConfig._location = Location.fromString(data['location']);
    userConfig._crashReportEnabled = data['enable_crash_report'].toInt() == 1;

    return userConfig;
  }
}
