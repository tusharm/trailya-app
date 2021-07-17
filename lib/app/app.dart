import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/screen/home_screen.dart';
import 'package:trailya/app/screen/signin_screen.dart';
import 'package:trailya/app/widgets/waiting.dart';
import 'package:trailya/model/config.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/services/auth.dart';
import 'package:trailya/services/sites_service.dart';
import 'package:trailya/services/visits_store.dart';

class App extends StatelessWidget {
  App({required this.visitsStore, required this.physicalDevice});

  static const String appTitle = 'trailya';

  final bool physicalDevice;
  final VisitsStore visitsStore;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: MultiProvider(
        providers: _buildProviders(),
        builder: (context, child) => _buildContents(context),
      ),
    );
  }

  List<SingleChildWidget> _buildProviders() {
    return [
      Provider(create: (_) => FirebaseAuthentication()),
      ChangeNotifierProvider(create: (_) => UserConfig()),
      ChangeNotifierProxyProvider<UserConfig, SitesNotifier>(
          create: (_) => SitesNotifier(sitesService: SitesService()),
          update: (context, userConfig, sitesNotifier) {
            sitesNotifier!.update(userConfig);
            return sitesNotifier;
          }),
      Provider.value(value: visitsStore),
    ];
  }

  Widget _buildContents(BuildContext context) {
    final auth = Provider.of<FirebaseAuthentication>(context, listen: false);

    return StreamBuilder<User?>(
      stream: auth.authStateChangesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return Waiting();
        }

        return snapshot.hasData
            ? HomeScreen()
            : SignInScreen.create(context, physicalDevice);
      },
    );
  }
}
