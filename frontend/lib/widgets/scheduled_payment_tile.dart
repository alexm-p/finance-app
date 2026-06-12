import 'package:flutter/material.dart';
import '../models/scheduled_payment.dart';

class ScheduledPaymentTile extends StatelessWidget {
  final ScheduledPayment payment;
  final VoidCallback? onTap;

  const ScheduledPaymentTile({
    super.key,
    required this.payment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colour = payment.isExpense
        ? Colors.red.shade400
        : Colors.green.shade500;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: colour.withOpacity(0.12),
        child: Icon(
          payment.isExpense ? Icons.autorenew : Icons.autorenew,
          color: colour,
          size: 20,
        ),
      ),
      title: Text(
        payment.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${_capitalise(payment.frequency)} · next ${_formatDate(payment.nextDue)}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            payment.formattedAmount,
            style: TextStyle(
              color: colour,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          if (!payment.isActive) ...[
            const SizedBox(width: 8),
            Icon(Icons.pause_circle_outline,
                size: 16,
                color: Theme.of(context).colorScheme.outline),
          ],
        ],
      ),
    );
  }

  String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}