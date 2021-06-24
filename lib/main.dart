import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/home_screen.dart';
import 'package:trailya/services/location_service.dart';
import 'package:trailya/services/sites_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: '.env');
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  await setupMessaging();

  final service = await LocationService.create();
  runApp(App(locationService: service,));
}

Future<void> setupMessaging() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  await FirebaseMessaging.instance.subscribeToTopic('test');
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Got a message whilst in the background!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print(
        'Message also contained a notification: ${message.notification!.title}');
  }
}

class App extends StatelessWidget {
  const App({Key? key, required this.locationService}) : super(key: key);

  final LocationService locationService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'trailya',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: MultiProvider(
        providers: [
          Provider(create: (_) => SitesService()),
          Provider(create: (_) => locationService)
        ],
        child: HomeScreen(),
      ),
    );
  }
}
