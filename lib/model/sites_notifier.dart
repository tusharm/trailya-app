import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:trailya/model/site.dart';
import 'package:trailya/model/user_config.dart';
import 'package:trailya/services/sites_service.dart';

class SitesNotifier extends ChangeNotifier {
  SitesNotifier._({required this.sitesService});

  /*
    Creates an instance, which itself depends upon another ChangeNotifier - UserConfig
   */
  static ChangeNotifierProxyProvider<UserConfig, SitesNotifier> create() {
    return ChangeNotifierProxyProvider<UserConfig, SitesNotifier>(
      create: (_) => SitesNotifier._(sitesService: SitesService()),
      update: (_, conf, notifier) {
        notifier!.update(conf);
        return notifier;
      },
    );
  }

  final SitesService sitesService;
  StreamSubscription<List<Site>>? streamSubscription;

  Site? currentSite;

  List<Site> _sites = [];

  List<Site> get sites => UnmodifiableListView(_sites);

  void update(UserConfig userConfig) {
    _setLocation(userConfig.location.toString());
  }

  Future<void> _setLocation(String location) async {
    if (streamSubscription != null) {
      await streamSubscription!.cancel();
    }

    streamSubscription = sitesService.getSites(location).listen((sites) {
      _sites = List.of(sites);
      notifyListeners();
    });
  }

  @override
  Future<void> dispose() async {
    if (streamSubscription != null) {
      await streamSubscription!.cancel();
    }

    super.dispose();
  }
}
