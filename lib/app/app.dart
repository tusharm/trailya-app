import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/app/screen/home_screen.dart';
import 'package:trailya/app/screen/signin_screen.dart';
import 'package:trailya/app/widgets/waiting.dart';
import 'package:trailya/services/auth.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'trailya',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: Provider(
        create: (_) => FirebaseAuthentication(),
        builder: (context, _) => _buildContents(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final auth = Provider.of<FirebaseAuthentication>(context, listen: false);

    return StreamBuilder<User?>(
      stream: auth.authStateChangesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return Waiting();
        }

        return snapshot.hasData ? HomeScreen() : SignInScreen.create(context);
      },
    );
  }
}
