import 'package:flutter/material.dart';
import 'package:go_muscu2/screens/home/settings/settings_page.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      color: Theme.of(context).colorScheme.secondary,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const SettingsPage();
            },
          ),
        );
      },
    );
  }
}
