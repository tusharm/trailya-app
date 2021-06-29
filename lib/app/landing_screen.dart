import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/home_screen.dart';
import 'package:trailya/app/signin_screen.dart';
import 'package:trailya/app/widgets/waiting.dart';
import 'package:trailya/services/auth.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthentication>(context, listen: false);

    // a builder that responds to events in the stream
    return StreamBuilder<User?>(
      stream: auth.authStateChangesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return snapshot.hasData ? HomeScreen() : SignInScreen.create(context);
        }

        return Waiting();
      },
    );
  }
}
