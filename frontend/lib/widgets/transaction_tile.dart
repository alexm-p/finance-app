// lib/widgets/transaction_tile.dart
// ─────────────────────────────────────────────────────
// A single row in the transactions list.
// Promoted to widgets/ because it will also appear on
// the dashboard screen's recent transactions section.
// ─────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  // Optional callback so the parent screen can react to a tap
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colour = transaction.isExpense
        ? Colors.red.shade400
        : Colors.green.shade500;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: colour.withOpacity(0.12),
        child: Text(
          transaction.initial,
          style: TextStyle(
            color: colour,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      title: Text(
        transaction.merchant,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        _formatDate(transaction.date),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Text(
        transaction.formattedAmount,
        style: TextStyle(
          color: colour,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
