import 'package:device_info_plus_platform_interface/model/android_device_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/landing.dart';
import 'package:trailya/model/config.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/services/auth.dart';
import 'package:trailya/services/message_service.dart';
import 'package:trailya/services/sites_service.dart';
import 'package:trailya/services/visits_store.dart';

class App extends StatelessWidget {
  App({required this.visitsStore, required this.deviceInfo});

  static const String appTitle = 'trailya';

  final VisitsStore visitsStore;
  final AndroidDeviceInfo? deviceInfo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: MultiProvider(
        providers: [
          Provider.value(value: deviceInfo),
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
