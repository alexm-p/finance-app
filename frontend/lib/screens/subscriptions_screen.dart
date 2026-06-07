// lib/screens/subscriptions_screen.dart
import 'package:flutter/material.dart';
import '../widgets/placeholder_screen.dart' as ps;

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ps.Placeholder(
      icon: Icons.autorenew_outlined,
      label: 'Subscriptions',
      hint: 'Manage recurring payments here',
    );
  }
}
