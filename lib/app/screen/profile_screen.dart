import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailya/model/user_config.dart';
import 'package:trailya/model/user_location.dart';
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
            SizedBox(height: 10),
            _buildBackgroundLocationSwitch(),
            SizedBox(height: 10),
            _buildCrashReportSwitch(),
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
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        RadioListTile<UserLocation>(
          title: Text('${UserLocation.NSW}'),
          value: UserLocation.NSW,
          groupValue: config.location,
          onChanged: _onChanged,
        ),
        RadioListTile<UserLocation>(
          title: Text('${UserLocation.VIC}'),
          value: UserLocation.VIC,
          groupValue: config.location,
          onChanged: _onChanged,
        ),
      ],
    );

    return _withinCard(widget, Colors.white);
  }

  Widget _buildCrashReportSwitch() {
    final widget = ListTile(
      isThreeLine: true,
      title: Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(
          'Enable crash reporting',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
      ),
      subtitle: Text(
        'Send crash reports to developers for efficient crash troubleshooting',
      ),
      trailing: Switch(
        value: config.crashReportEnabled,
        activeColor: Colors.indigoAccent,
        onChanged: (value) => config.crashReportEnabled = value,
      ),
    );
    return _withinCard(widget, Colors.white);
  }

  Widget _buildBackgroundLocationSwitch() {
    final widget = ListTile(
      isThreeLine: true,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          'Enable background location',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
      ),
      subtitle: Text(
        'Allow app to track your locations in the background, even when it\' not being used actively. Please select "Allow all the time" from system settings.',
      ),
      trailing: Switch(
        value: config.bgLocationEnabled,
        activeColor: Colors.indigoAccent,
        onChanged: (value) => config.bgLocationEnabled = value,
      ),
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

  void _onChanged(UserLocation? value) {
    config.location = value;
  }
}
