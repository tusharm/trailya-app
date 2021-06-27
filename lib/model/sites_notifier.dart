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

  Site? get currentSite {
    if (_currentIndex == null) {
      return null;
    }

    return _sites[_currentIndex!];
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
