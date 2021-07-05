import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/model/config.dart';
import 'package:trailya/services/auth.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({required this.config});

  static Widget create() {
    return Consumer<UserConfig>(
      builder: (context, config, _) => ProfileScreen(config: config),
    );
  }

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
            SizedBox(height: 10),
            _buildUserInfo(user),
            SizedBox(height: 10),
            _buildStateSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    final info = user.email != null
        ? user.email!
        : (user.isAnonymous ? 'Anonymous' : '');

    final widget = Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3.0,
            ),
          ),
          child: CircleAvatar(
            maxRadius: 50,
            backgroundImage: NetworkImage(
              user.photoURL != null
                  ? user.photoURL!
                  : 'https://source.unsplash.com/random?australia',
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          info,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        )
      ],
    );
    return _withinCard(widget, Colors.indigo.shade300);
  }

  Card _buildStateSelector() {
    final widget = Column(
      children: [
        Text(
          'Choose preferred location',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 20),
        RadioListTile<Location>(
          title: Text('${Location.NSW}'),
          value: Location.NSW,
          groupValue: config.location,
          onChanged: _onChanged,
        ),
        RadioListTile<Location>(
          title: Text('${Location.VIC}'),
          value: Location.VIC,
          groupValue: config.location,
          onChanged: _onChanged,
        ),
      ],
    );

    return _withinCard(widget, Colors.white);
  }

  Card _withinCard(Widget widget, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: widget,
      ),
    );
  }

  void _onChanged(Location? value) {
    config.location = value!;
  }
}
