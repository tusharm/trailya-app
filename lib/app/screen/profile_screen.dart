import 'package:flutter/material.dart';
import 'package:trailya/model/config.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({required this.config});

  final UserConfig config;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(),
              child: Column(
                children: [
                  RadioListTile<Location>(
                    title: Text(Location.NSW.asString()),
                    value: Location.NSW,
                    groupValue: config.location,
                    onChanged: _onChanged,
                  ),
                  RadioListTile<Location>(
                    title: Text(Location.VIC.asString()),
                    value: Location.VIC,
                    groupValue: config.location,
                    onChanged: _onChanged,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onChanged(Location? value) {
    config.location = value!;
  }
}
