import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:trailya/model/config.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/services/sites_service.dart';

class SitesNotifier extends ChangeNotifier {
  SitesNotifier({required this.sitesService});

  Site? _selectedSite;
  DateTime? _selectedExposureDate;
  List<Site> _sites = [];
  final SitesService sitesService;
  StreamSubscription<List<Site>>? streamSubscription;

  List<Site> get sites => UnmodifiableListView(_sites);

  List<Site> get filteredSites {
    final sites = _sites.where((site) {
      if (_selectedExposureDate == null) return true;

      final exposureStart = site.exposureStartTime;
      return exposureStart.isAfter(_selectedExposureDate!) &&
          exposureStart.isBefore(_selectedExposureDate!.add(Duration(days: 1)));
    });
    return UnmodifiableListView(sites);
  }

  Site? get currentSite => (_selectedSite == null) ? null : _selectedSite!;

  DateTime? get selectedExposureDate => _selectedExposureDate;

  set selectedExposureDate(DateTime? date) {
    _selectedExposureDate = date;
    notifyListeners();
  }

  void update(UserConfig userConfig) {
    _setLocation(userConfig.location.toString());
  }

  void setSelectedSite(Site site) {
    _selectedSite = site;
    notifyListeners();
  }

  Future<void> _setLocation(String location) async {
    if (streamSubscription != null) {
      await streamSubscription!.cancel();
    }

    streamSubscription = sitesService.getSites(location).listen((sites) {
      _refreshSites(sites);
    });
  }

  void _refreshSites(List<Site> sites) {
    _sites = List.of(sites);
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    if (streamSubscription != null) {
      await streamSubscription!.cancel();
    }

    super.dispose();
  }
}
