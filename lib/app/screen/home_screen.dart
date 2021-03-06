import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/screen/map_screen.dart';
import 'package:trailya/app/screen/profile_screen.dart';
import 'package:trailya/app/screen/sites_screen.dart';
import 'package:trailya/app/widgets/custom_menu_button.dart';
import 'package:trailya/app/widgets/dialog.dart' as dlg;
import 'package:trailya/app/widgets/waiting.dart';
import 'package:trailya/model/filters.dart';
import 'package:trailya/model/location_notifier.dart';
import 'package:trailya/model/sites_notifier.dart';
import 'package:trailya/model/user_config.dart';
import 'package:trailya/services/auth.dart';
import 'package:trailya/services/background.dart';
import 'package:trailya/services/location_service.dart';
import 'package:trailya/services/message_service.dart';
import 'package:trailya/stores/config_store.dart';
import 'package:trailya/stores/visits_store.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _Services? services;
  MessageService? messageService;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthentication>(context, listen: false);
    return _buildProviders(auth.currentUser!, _buildContents);
  }

  Widget _buildProviders(
          User user, Widget Function(BuildContext context) buildContent) =>
      FutureBuilder<_Services>(
        future: _init(user),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Waiting();
          }

          services = snapshot.data!;

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<UserConfig>.value(
                value: services!.userConfig,
              ),
              Provider.value(value: services!.locationService),
              SitesNotifier.create(),
              LocationNotifier.create(services!.visitsStore),
              ChangeNotifierProvider(create: (_) => Filters()),
            ],
            builder: (context, _) => buildContent(context),
          );
        },
      );

  Widget _buildContents(BuildContext context) {
    messageService = MessageService.create(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Center(
            child: Image.asset(
              'assets/trailya.png',
              width: 90,
            ),
          ),
          elevation: 5.0,
          toolbarHeight: 120,
          actions: [
            CustomMenuButton(
              onLogout: () => _confirmSignOut(context),
              onPrivacyClick: _launchPrivacyPolicy,
              onAboutClick: () async =>
                  await dlg.showAboutDialog(context, services!.packageInfo),
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map_outlined)),
              Tab(icon: Icon(Icons.format_list_numbered_outlined)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: Consumer<SitesNotifier>(
            builder: (c, sitesNotifier, _) => TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    MapScreen(),
                    SitesScreen(),
                    ProfileScreen.create(),
                  ],
                )),
      ),
    );
  }

  Future<_Services> _init(User user) async {
    final packageInfo = await PackageInfo.fromPlatform();
    await scheduleBackgroundJob();

    // load UserConfig from local store
    final configStore = await ConfigStore.create();
    final userConfig = await configStore.get(user);
    userConfig.addListener(() {
      configStore.save(userConfig);
    });

    final locationService =
        await LocationService.create(userConfig.bgLocationEnabled);
    userConfig.addListener(() {
      locationService.update(userConfig);
    });

    final visitsStore = await VisitsStore.create();
    return _Services(locationService, visitsStore, userConfig, packageInfo);
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthentication>(context, listen: false);
      await auth.signOut();
    } on Exception catch (e) {
      await dlg.showExceptionAlertDialog(
        context,
        title: 'Sign out failed',
        exception: e,
      );
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await dlg.showAlertDialog(
      context,
      title: 'Logout',
      content: Text('Are you sure that you want to logout?'),
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );

    if (didRequestSignOut == true) {
      await _signOut(context);
    }
  }

  void _launchPrivacyPolicy() async {
    final url = 'https://github.com/tusharm/trailya-app/blob/main/PRIVACY.md';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Privacy Policy link';
    }
  }

  @override
  void dispose() {
    if (messageService != null) {
      messageService!.dispose();
    }

    if (services != null) {
      services!.dispose();
    }

    super.dispose();
  }
}

class _Services {
  _Services(this.locationService, this.visitsStore, this.userConfig,
      this.packageInfo);

  final LocationService locationService;
  final VisitsStore visitsStore;
  final UserConfig userConfig;
  final PackageInfo packageInfo;

  Future<void> dispose() async {
    await locationService.dispose();
  }
}
