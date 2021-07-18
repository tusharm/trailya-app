import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trailya/services/background.dart';
import 'package:trailya/services/visits_store.dart';
import 'package:trailya/utils/assets.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kDebugMode) {
    await _run();
    return;
  }

  // We're not running in debug mode,
  // so enable Crashlytics to catch every error

  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);

  await runZonedGuarded<Future<void>>(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    await _run();
  }, FirebaseCrashlytics.instance.recordError);
}

Future<void> _run() async {
  await Assets.init();
  await scheduleBackgroundJob();

  final store = await VisitsStore.create();
  runApp(App(visitsStore: store));
}
