// lib/widgets/summary_card.dart
// ─────────────────────────────────────────────────────
// Shows total spent this month above the transactions list.
// Also used on the dashboard screen — that's why it lives
// in widgets/ rather than inside transactions_screen.dart.
// ─────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/transaction.dart';

class SummaryCard extends StatelessWidget {
  final List<Transaction> transactions;

  const SummaryCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Only count expenses from the current month
    final monthlyExpenses = transactions.where((t) =>
        t.isExpense &&
        t.date.month == now.month &&
        t.date.year == now.year);

    final totalSpent = monthlyExpenses.fold(
        0.0, (sum, t) => sum + t.amount.abs());

    final totalIn = transactions
        .where((t) =>
            !t.isExpense &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Stat(
              label: 'Spent this month',
              value: '£${totalSpent.toStringAsFixed(2)}',
              valueColour: Colors.red.shade600,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.2),
          ),
          Expanded(
            child: _Stat(
              label: 'Income this month',
              value: '£${totalIn.toStringAsFixed(2)}',
              valueColour: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColour;

  const _Stat({
    required this.label,
    required this.value,
    required this.valueColour,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: valueColour,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
