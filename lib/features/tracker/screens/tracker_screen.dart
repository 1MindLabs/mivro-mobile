import 'package:flutter/material.dart';
import 'package:mivro/core/app_constants.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 80,
              color: mivroGreen.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: mivroGreen,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tracker',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
