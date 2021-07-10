import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar({required String text})
      : super(
          behavior: SnackBarBehavior.fixed,
          duration: Duration(seconds: 10),
          backgroundColor: Colors.indigo.shade300,
          content: Text(
            text,
            textAlign: TextAlign.center,
          ),
        );
}
