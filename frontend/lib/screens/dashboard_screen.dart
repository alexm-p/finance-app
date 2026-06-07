// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../widgets/placeholder_screen.dart' as ps;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ps.Placeholder(
      icon: Icons.dashboard_outlined,
      label: 'Overview',
      hint: 'Charts and summaries will appear here',
    );
  }
}
