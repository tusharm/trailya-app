import 'package:flutter/material.dart';
import 'package:trailya/model/place.dart';
import 'package:trailya/model/site.dart';

class Filters extends ChangeNotifier {
  DateTime? _exposureDate;

  DateTime? get exposureDate => _exposureDate;

  set exposureDate(DateTime? exposureDate) {
    _exposureDate = exposureDate;
    notifyListeners();
  }

  bool withinExposureDate<T extends Place>(T place) {
    if (_exposureDate == null) return true;

    return !place.start.isBefore(_exposureDate!) &&
        !place.start.isAfter(_exposureDate!.add(Duration(days: 1)));
  }

  bool _showVisitsOnly = false;

  bool get showVisitsOnly => _showVisitsOnly;

  set showVisitsOnly(bool enabled) {
    _showVisitsOnly = enabled;
    notifyListeners();
  }

  String? _suburb;

  String? get suburb => _suburb;

  set suburb(String? suburb) {
    _suburb = suburb;
    notifyListeners();
  }

  bool filterSuburb(Site site) {
    if (_suburb == null) return true;
    return site.suburb == _suburb;
  }

  void clearAll() {
    _exposureDate = null;
    _showVisitsOnly = false;
    _suburb = null;

    notifyListeners();
  }
}
