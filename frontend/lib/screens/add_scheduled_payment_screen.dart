import 'package:flutter/material.dart';
import '../services/scheduled_payment_service.dart';

class AddScheduledPaymentScreen extends StatefulWidget {
  const AddScheduledPaymentScreen({super.key});

  @override
  State<AddScheduledPaymentScreen> createState() =>
      _AddScheduledPaymentScreenState();
}

class _AddScheduledPaymentScreenState
    extends State<AddScheduledPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  final _service = ScheduledPaymentService();
  bool _isExpense = true;
  bool _isLoading = false;
  String _frequency = 'monthly';
  DateTime _nextDue = DateTime.now().add(const Duration(days: 30));

  static const _frequencies = ['daily', 'weekly', 'monthly', 'yearly'];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextDue,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _nextDue = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final rawAmount = double.parse(_amountController.text.trim());
      final amount = _isExpense ? -rawAmount.abs() : rawAmount.abs();

      await _service.createScheduledPayment(
        name:      _nameController.text.trim(),
        amount:    amount,
        frequency: _frequency,
        nextDue:   _nextDue,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    final dateLabel =
        '${_nextDue.day} ${months[_nextDue.month - 1]} ${_nextDue.year}';

    return Scaffold(
      appBar: AppBar(title: const Text('Add scheduled payment')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true,  label: Text('Expense')),
                ButtonSegment(value: false, label: Text('Income')),
              ],
              selected: {_isExpense},
              onSelectionChanged: (s) => setState(() => _isExpense = s.first),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount (£)',
                border: OutlineInputBorder(),
                prefixText: '£ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (double.tryParse(v.trim()) == null) return 'Enter a number';
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
              ),
              items: _frequencies
                  .map((f) => DropdownMenuItem(
                        value: f,
                        child: Text(f[0].toUpperCase() + f.substring(1)),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _frequency = v!),
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Next due'),
              trailing: Text(dateLabel),
              onTap: _pickDate,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 32),

            FilledButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save payment'),
            ),
          ],
        ),
      ),
    );
  }
}