// lib/models/transaction.dart
// ─────────────────────────────────────────────────────
// Mirrors the Pydantic schemas in schemas/transaction.py.
// TransactionSummary is used in list views (lighter).
// Transaction is used when viewing a single item in full.
// ─────────────────────────────────────────────────────
 
class Transaction {
  final int id;
  final double amount;
  final String merchant;
  final String? description;
  final DateTime date;
  final String source;
  final int? categoryId;
  final DateTime createdAt;
 
  const Transaction({
    required this.id,
    required this.amount,
    required this.merchant,
    this.description,
    required this.date,
    required this.source,
    this.categoryId,
    required this.createdAt,
  });
 
  // Whether this is money going out
  bool get isExpense => amount < 0;
 
  // Formatted amount string e.g. "-£12.50" or "+£500.00"
  String get formattedAmount {
    final abs = amount.abs().toStringAsFixed(2);
    return isExpense ? '-£$abs' : '+£$abs';
  }
 
  // First letter of merchant, uppercased — used in avatar
  String get initial => merchant.isNotEmpty ? merchant[0].toUpperCase() : '?';
 
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      // API may return int or double — (num) cast handles both safely
      amount: (json['amount'] as num).toDouble(),
      merchant: json['merchant'] as String,
      description: json['description'] as String?,
      date: DateTime.parse(json['date'] as String),
      source: json['source'] as String? ?? 'manual',
      categoryId: json['category_id'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
 
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'merchant': merchant,
        'description': description,
        'date': date.toIso8601String(),
        'source': source,
        'category_id': categoryId,
      };
}
 
 