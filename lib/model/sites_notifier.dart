import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/services/sites_service.dart';

class SitesNotifier extends ChangeNotifier {

  SitesNotifier({required this.sitesService}) {
    streamSubscription = setLocation('NSW');
  }

  Site? _selectedSite;
  List<Site> _sites = [];
  final SitesService sitesService;
  late StreamSubscription<List<Site>> streamSubscription;

  List<Site> get sites => UnmodifiableListView(_sites);

  Site? get currentSite => (_selectedSite == null) ? null : _selectedSite!;

  void setSelectedSite(Site site) {
    _selectedSite = site;
    notifyListeners();
  }

  // Will be called from the Profile page
  StreamSubscription<List<Site>> setLocation(String location) {
    return sitesService.getSites(location).listen((sites) {
      _refreshSites(sites);
    });
  }

  void _refreshSites(List<Site> sites) {
    _sites = List.of(sites);
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await streamSubscription.cancel();
    super.dispose();
  }
}
