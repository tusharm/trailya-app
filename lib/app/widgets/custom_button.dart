import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.child,
    required this.color,
    required this.onPressed,
    this.height = 50.0,
  });

  final double height;
  final Widget child;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
