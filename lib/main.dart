import 'package:flutter/material.dart';

import 'app/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Am I Linked?',
      theme: new ThemeData(primarySwatch: Colors.indigo),
      home: HomePage(),
    );
  }
}

