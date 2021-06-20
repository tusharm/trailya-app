import 'package:flutter/material.dart';

class CenteredContent extends StatelessWidget {
  const CenteredContent({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.black54, fontSize: 32.0),
            ),
            Text(
              message,
              style: TextStyle(color: Colors.black54, fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }
}
