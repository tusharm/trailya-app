import 'package:flutter/material.dart';

class Waiting extends StatelessWidget {
  const Waiting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
