import 'package:flutter/material.dart';
import '../models/scheduled_payment.dart';
import '../services/scheduled_payment_service.dart';
import '../widgets/scheduled_payment_tile.dart';
import '../widgets/summary_card.dart';
import 'add_scheduled_payment_screen.dart';

class ScheduledPaymentScreen extends StatefulWidget {
  const ScheduledPaymentScreen({super.key});

  @override
  State<ScheduledPaymentScreen> createState() => _ScheduledPaymentScreenState();
}

class _ScheduledPaymentScreenState extends State<ScheduledPaymentScreen> {
  final _service = ScheduledPaymentService();
  late Future<List<ScheduledPayment>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _service.getScheduledPayments();
  }

  void _refresh() => setState(() => _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ScheduledPayment>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('Could not load scheduled payments',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('${snapshot.error}',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: _refresh, child: const Text('Retry')),
                ],
              ),
            );
          }

          final payments = snapshot.data!;

          if (payments.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.autorenew_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('No scheduled payments',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Tap + to add one',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            );
          }

          // Reuse SummaryCard by converting ScheduledPayment → a duck-typed
          // summary of what's due this month. We can't pass ScheduledPayment
          // directly because SummaryCard expects List<Transaction>.
          // Instead, show a simpler inline summary for scheduled payments.
          final monthlyExpense = payments
              .where((p) => p.isExpense && p.isActive)
              .fold(0.0, (s, p) => s + p.amount.abs());
          final monthlyIncome = payments
              .where((p) => !p.isExpense && p.isActive)
              .fold(0.0, (s, p) => s + p.amount);

          return Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Text('Scheduled payments',
                      style: Theme.of(context).textTheme.headlineSmall),
                ]),
              ),
              // Inline summary card — same visual style as SummaryCard
              Container(
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
                        label: 'Total outgoing',
                        value: '£${monthlyExpense.toStringAsFixed(2)}',
                        valueColour: Colors.red.shade600,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withOpacity(0.2),
                    ),
                    Expanded(
                      child: _Stat(
                        label: 'Total incoming',
                        value: '£${monthlyIncome.toStringAsFixed(2)}',
                        valueColour: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _refresh(),
                  child: ListView.builder(
                    itemCount: payments.length,
                    itemBuilder: (context, i) => ScheduledPaymentTile(
                      payment: payments[i],
                      onTap: () {
                        // TODO: navigate to detail/edit screen
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AddScheduledPaymentScreen()),
          );
          _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColour;

  const _Stat({required this.label, required this.value, required this.valueColour});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text(value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: valueColour, fontWeight: FontWeight.w600)),
      ],
    );
  }
}