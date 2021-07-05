import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/landing.dart';
import 'package:trailya/model/config.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/services/auth.dart';
import 'package:trailya/services/sites_service.dart';
import 'package:trailya/services/visits_store.dart';

class App extends StatelessWidget {
  App({required this.visitsStore});

  static const String appTitle = 'trailya';

  final VisitsStore visitsStore;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: MultiProvider(
        providers: [
          Provider(create: (_) => FirebaseAuthentication()),
          ChangeNotifierProvider(create: (_) => UserConfig()),
          ChangeNotifierProxyProvider<UserConfig, SitesNotifier>(
              create: (_) => SitesNotifier(sitesService: SitesService()),
              update: (context, userConfig, sitesNotifier) {
                sitesNotifier!.update(userConfig);
                return sitesNotifier;
              }),
          Provider.value(value: visitsStore),
        ],
        child: Landing(),
      ),
    );
  }
}
