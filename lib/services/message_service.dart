import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/widgets/snack_bar.dart';
import 'package:trailya/model/user_config.dart';

class MessageService {
  MessageService._(BuildContext context) {
    onMessageSubscription = FirebaseMessaging.onMessage
        .listen((event) => _messageHandler(event, context));

    FirebaseMessaging.instance.subscribeToTopic(generalTopic);
  }

  factory MessageService.create(BuildContext context) {
    final userConfig = Provider.of<UserConfig>(context, listen: false);

    final messageService = MessageService._(context);
    userConfig.addListener(() {
      messageService.subscribeToSite(userConfig.location.state);
    });

    return messageService;
  }

  static const String generalTopic = 'General';
  late final StreamSubscription<RemoteMessage> onMessageSubscription;
  String? _currentSiteTopic;

  void _messageHandler(RemoteMessage event, BuildContext context) {
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
  }

  Future<void> subscribeToSite(String newTopic) async {
    if (_currentSiteTopic != null) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(_currentSiteTopic!);
    }

    await FirebaseMessaging.instance.subscribeToTopic(newTopic);
    _currentSiteTopic = newTopic;
  }

  void dispose() {
    onMessageSubscription.cancel();
    FirebaseMessaging.instance.unsubscribeFromTopic(generalTopic);

    if (_currentSiteTopic != null) {
      FirebaseMessaging.instance.unsubscribeFromTopic(_currentSiteTopic!);
    }
  }
}
