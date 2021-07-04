import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trailya/services/visits_store.dart';
import 'package:trailya/utils/assets.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  // await setupMessaging();

  await Assets.init();
  final store = await VisitsStore.create();
  runApp(App(
    visitsStore: store,
  ));
}
