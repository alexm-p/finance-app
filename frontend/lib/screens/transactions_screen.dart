// lib/screens/transactions_screen.dart
// ─────────────────────────────────────────────────────
// Shows the SummaryCard + paginated list of transactions.
// The FAB navigates to AddTransactionScreen and refreshes
// the list on return.
// ─────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/summary_card.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _service = TransactionService();
  late Future<List<Transaction>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _service.getTransactions();
  }

  // Called after returning from AddTransactionScreen to refresh the list
  void _refresh() {
    setState(() => _load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar here — AppShell in main.dart owns the nav bar,
      // but each screen can have its own top area if needed.
      body: FutureBuilder<List<Transaction>>(
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
                  Text('Could not load transactions',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('${snapshot.error}',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final transactions = snapshot.data!;

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('No transactions yet',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Tap + to add your first one',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Safe area padding for status bar
              SizedBox(height: MediaQuery.of(context).padding.top + 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('Transactions',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
              SummaryCard(transactions: transactions),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _refresh(),
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, i) => TransactionTile(
                      transaction: transactions[i],
                      onTap: () {
                        // TODO: navigate to transaction detail screen
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
          // Wait for AddTransactionScreen to close, then refresh
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AddTransactionScreen()),
          );
          _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
