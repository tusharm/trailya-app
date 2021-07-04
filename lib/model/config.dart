import 'package:flutter/material.dart';

enum Location { NSW, VIC }

extension LocationExtensions on Location {
  String asString() {
    return toString().split('.').last;
  }
}

class UserConfig extends ChangeNotifier {
  Location _location = Location.NSW;

  Location get location => _location;

  set location(loc) {
    _location = loc;
    notifyListeners();
  }
}
