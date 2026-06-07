// lib/screens/income_screen.dart
import 'package:flutter/material.dart';
import '../widgets/placeholder_screen.dart' as ps;

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ps.Placeholder(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Income',
      hint: 'Track your monthly income here',
    );
  }
}
