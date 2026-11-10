import 'package:flutter/material.dart';

import 'page_background.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DestinationPage(
        title: 'INVENTORY',
        icon: Icons.work_outline_rounded,
      ),
    );
  }
}
