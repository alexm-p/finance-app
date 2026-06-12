class ScheduledPayment {
  final int id;
  final String name;
  final double amount;
  final String frequency;
  final DateTime nextDue;
  final int? categoryId;
  final String? merchant;
  final bool isActive;

  ScheduledPayment({
    required this.id,
    required this.name,
    required this.merchant,
    required this.amount,
    required this.frequency,
    required this.nextDue,
    this.categoryId,
    required this.isActive,
  });

  bool get isExpense => amount < 0;

  String get formattedAmount {

    final abs = amount.abs().toStringAsFixed(2);
    return isExpense ? '-£$abs' : '+£$abs';

  }

  factory ScheduledPayment.fromJson(Map<String, dynamic> json) {
    return ScheduledPayment(
      id:         json['id'],
      name:       json['name'],
      amount:     (json['amount'] as num).toDouble(),
      merchant:   json['merchant'] as String? ?? '',
      frequency:  json['frequency'],
      nextDue:    DateTime.parse(json['next_due']),
      categoryId: json['category_id'] as int?,
      isActive:   json['is_active'] as bool? ?? true,
    );
  }
}