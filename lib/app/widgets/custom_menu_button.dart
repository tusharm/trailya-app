import 'package:flutter/material.dart';

class _MenuItem {
  _MenuItem(this.text, this.icon);

  final Text text;
  final Widget icon;
}

class CustomMenuButton extends StatelessWidget {
  const CustomMenuButton({
    required this.onLogout,
    required this.onPrivacyClick,
    required this.onAboutClick,
  });

  static final logoutItem = _MenuItem(
    Text('Log out'),
    Icon(
      Icons.logout,
      color: Colors.black,
      size: 20,
    ),
  );

  static final privacyItem = _MenuItem(
    Text('Privacy Policy'),
    Icon(
      Icons.open_in_new,
      color: Colors.black,
      size: 20,
    ),
  );

  static final aboutItem = _MenuItem(
    Text('About'),
    ImageIcon(
      AssetImage('assets/shoe.png'),
      color: Colors.black,
      size: 25,
    ),
  );

  final VoidCallback onLogout;
  final VoidCallback onPrivacyClick;
  final VoidCallback onAboutClick;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuItem>(
      onSelected: _onSelection,
      itemBuilder: (context) => <PopupMenuEntry<_MenuItem>>[
        PopupMenuItem<_MenuItem>(
          value: logoutItem,
          child: Row(
            children: [
              logoutItem.icon,
              SizedBox(width: 12.0),
              logoutItem.text,
            ],
          ),
        ),
        PopupMenuItem<_MenuItem>(
          value: privacyItem,
          child: Row(
            children: [
              privacyItem.icon,
              SizedBox(width: 12.0),
              privacyItem.text,
            ],
          ),
        ),
        PopupMenuItem<_MenuItem>(
          value: aboutItem,
          child: Row(
            children: [
              aboutItem.icon,
              SizedBox(width: 12.0),
              aboutItem.text,
            ],
          ),
        )
      ],
    );
  }

  void _onSelection(_MenuItem value) {
    if (value == logoutItem) {
      onLogout();
    } else if (value == privacyItem) {
      onPrivacyClick();
    } else if (value == aboutItem) {
      onAboutClick();
    }
  }
}
