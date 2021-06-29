import 'package:flutter/material.dart';
import 'package:trailya/app/widgets/custom_button.dart';

class CustomButtonWithAsset extends CustomButton {
  CustomButtonWithAsset({
    required String text,
    required String asset,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(asset),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: textColor,
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(asset),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
