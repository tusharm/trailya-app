import 'package:amilinked/app/store/db_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/home.dart';
import 'app/store/site.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  await setupMessaging();

  runApp(App());
}

Future<void> setupMessaging() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    await handleSitesUpdateMessage(message);
  });

  await FirebaseMessaging.instance.subscribeToTopic('test');
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Got a message whilst in the background!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }

  await handleSitesUpdateMessage(message);
}

Future<void> handleSitesUpdateMessage(RemoteMessage message) async {
  await DataBaseHelper().persist(Site(
    id: message.data['id'],
    suburb: message.data['Suburb'],
    name: message.data['Site_title'],
    address: message.data['Site_streetaddress'],
    state: message.data['Site_state'],
    postcode: message.data['Site_postcode'],
    exposureDate: message.data['Exposure_date_dtm'],
    exposureStartTime: message.data['Exposure_time_start_24'],
    exposureEndTime: message.data['Exposure_time_end_24'],
  ));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Am I Linked?',
        theme: new ThemeData(primarySwatch: Colors.indigo),
        home: HomePage());
  }
}
