import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Am I Linked?',
          theme: new ThemeData(primarySwatch: Colors.indigo),
          home: _buildContent(context, snapshot),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Text('Error initializing Firebase'),
        ),
      );
    }

    // Once complete, show your application
    if (snapshot.connectionState == ConnectionState.done) {
      return HomePage();
    }

    // Otherwise, show something whilst waiting for initialization to complete
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
