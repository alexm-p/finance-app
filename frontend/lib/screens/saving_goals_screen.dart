// lib/screens/saving_goals_screen.dart
import 'package:flutter/material.dart';
import '../widgets/placeholder_screen.dart' as ps;

class SavingGoalsScreen extends StatelessWidget {
  const SavingGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ps.Placeholder(
      icon: Icons.savings_outlined,
      label: 'Saving goals',
      hint: 'Set targets and track progress here',
    );
  }
}
