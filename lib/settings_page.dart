import 'package:flutter/material.dart';

import 'page_background.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DestinationPage(
        title: 'SETTINGS',
        icon: Icons.settings_rounded,
      ),
    );
  }
}
