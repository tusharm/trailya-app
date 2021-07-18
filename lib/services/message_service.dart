import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:trailya/app/widgets/snack_bar.dart';

class MessageService {
  MessageService(BuildContext context) {
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        // process notifications only if 'type' == 'sites_update'
        if (event.data['type'] == 'sites_update') {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
              text: event.notification!.body!,
            ),
          );
        }
      }
    });

    FirebaseMessaging.instance.subscribeToTopic(generalTopic);
  }

  static const String generalTopic = 'General';
  String? _currentSiteTopic;

  Future<void> subscribeToSite(String newTopic) async {
    if (_currentSiteTopic != null) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(_currentSiteTopic!);
    }

    await FirebaseMessaging.instance.subscribeToTopic(newTopic);
    _currentSiteTopic = newTopic;
  }
}
