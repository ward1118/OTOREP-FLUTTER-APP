import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'page_background.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    const history = [
      ('PC-09 | ADV.LAB', 'Marked for service', 'Today, 10:42 AM'),
      ('PC-07 | MAC LAB', 'Updated device details', 'Yesterday, 3:18 PM'),
      ('PC-01 | ADV.LAB', 'Maintenance completed', 'Sep 20, 2026'),
    ];

    return Scaffold(
      body: OtorepPageBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Expanded(
                    child: Text(
                      'ARCHIVE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                  ),
                  child: ListView.separated(
                    itemCount: history.length,
                    separatorBuilder: (_, _) => const Divider(color: Colors.white24),
                    itemBuilder: (context, index) {
                      final entry = history[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.history, color: Colors.white),
                        title: Text(
                          entry.$1,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          '${entry.$2}\n${entry.$3}',
                          style: const TextStyle(color: Colors.white, height: 1.4),
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
