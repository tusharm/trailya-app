import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> setupMessaging() async {
  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    if (message.notification != null) {
      print('Message contains a notification: ${message.notification}');
    }

    await Future.delayed(Duration(milliseconds: 1));
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print('Message contains a notification: ${message.notification}');
    }
  });

  await FirebaseMessaging.instance.subscribeToTopic('test');
}
