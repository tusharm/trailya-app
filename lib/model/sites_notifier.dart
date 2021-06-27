import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trailya/model/site.dart';

class SitesNotifier extends ChangeNotifier {
  List<Site> _sites = [];
  int? _currentIndex;
  final _location = 'NSW';

  String get location => _location;
  List<Site> get sites => UnmodifiableListView(_sites);

  LatLng? get currentSite {
    if (_currentIndex == null) {
      return null;
    }

    final site = _sites[_currentIndex!];
    return LatLng(site.latitude!, site.longitude!);
  }

  void refreshSites(List<Site> sites) {
    _sites = List.of(sites);
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
