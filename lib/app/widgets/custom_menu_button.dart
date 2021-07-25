
import 'package:flutter/material.dart';

class _MenuItem {
  _MenuItem(this.text, this.icon);

  final String text;
  final IconData icon;
}

class CustomMenuButton extends StatelessWidget {
  const CustomMenuButton({
    required this.onLogout,
    required this.onPrivacyClick,
  });

  static final logoutItem = _MenuItem('Log out', Icons.logout);
  static final privacyItem = _MenuItem('Privacy Policy', Icons.open_in_new);

  final VoidCallback onLogout;
  final VoidCallback onPrivacyClick;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuItem>(
      onSelected: _onSelection,
      itemBuilder: (context) => <PopupMenuEntry<_MenuItem>>[
        PopupMenuItem<_MenuItem>(
          value: logoutItem,
          child: Row(
            children: [
              Icon(logoutItem.icon, color: Colors.black, size: 20),
              SizedBox(width: 12.0),
              Text(logoutItem.text),
            ],
          ),
        ),
        PopupMenuItem<_MenuItem>(
          value: privacyItem,
          child: Row(
            children: [
              Icon(privacyItem.icon, color: Colors.black, size: 20),
              SizedBox(width: 12.0),
              Text(privacyItem.text),
            ],
          ),
        ),
      ],
    );
  }

  void _onSelection(_MenuItem value) {
      if (value == logoutItem) {
        onLogout();
      } else if (value == privacyItem) {
        onPrivacyClick();
      } else {}
    }
}
