import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/model/config.dart';
import 'package:trailya/services/auth.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({required this.config});

  final UserConfig config;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthentication>(context, listen: false);
    final user = auth.currentUser!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAvatar(user),
            SizedBox(height: 10),
            if (user.email != null)
              Text(
                user.email!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            SizedBox(height: 20),
            _buildStateSelector()
          ],
        ),
      ),
    );
  }

  Card _buildStateSelector() {
    return Card(
      shape: RoundedRectangleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Choose state',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
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
      ),
    );
  }

  CircleAvatar _buildAvatar(User user) {
    return CircleAvatar(
      radius: 50,
      backgroundImage:
          user.photoURL != null ? NetworkImage(user.photoURL!) : null,
      child: user.photoURL == null ? Icon(Icons.camera_alt, size: 50) : null,
    );
  }

  void _onChanged(Location? value) {
    config.location = value!;
  }
}
