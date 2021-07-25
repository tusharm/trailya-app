import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trailya/model/user_location.dart';

class UserConfig extends ChangeNotifier {
  UserConfig({
    required this.id,
  });

  final String id;

  UserLocation _location = UserLocation.NSW;

  UserLocation get location => _location;

  set location(loc) {
    _location = loc;
    notifyListeners();
  }

  bool _crashReportEnabled = !kDebugMode;

  bool get crashReportEnabled => _crashReportEnabled;

  set crashReportEnabled(bool enabled) {
    _crashReportEnabled = enabled;
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled);
    notifyListeners();
  }

  bool _bgLocationEnabled = false;

  bool get bgLocationEnabled => _bgLocationEnabled;

  set bgLocationEnabled(bool enabled) {
    print('Background location enabled? ${enabled}');
    _bgLocationEnabled = enabled;
    notifyListeners();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'enable_crash_report': _crashReportEnabled ? 1 : 0,
        'enable_background_location': _bgLocationEnabled ? 1 : 0,
        'location': _location.state,
      };

  static UserConfig fromMap(Map<String, dynamic> data) {
    final userConfig = UserConfig(id: data['id'].toString());
    userConfig._location = UserLocation.fromString(data['location']);
    userConfig._crashReportEnabled = data['enable_crash_report'].toInt() == 1;
    userConfig._bgLocationEnabled = data['enable_background_location'].toInt() == 1;

    return userConfig;
  }
}
