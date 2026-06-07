// lib/widgets/placeholder_screen.dart
// ─────────────────────────────────────────────────────
// Used by screens that haven't been built yet.
// Import this in each placeholder screen file.
// Delete it screen-by-screen as you replace placeholders
// with real implementations.
// ─────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class Placeholder extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;

  const Placeholder({
    required this.icon,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 64,
              color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text(label,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(hint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  )),
        ],
      ),
    );
  }
}
