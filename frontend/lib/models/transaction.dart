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
 
  // ── these are the two that were missing ──
 
  bool get isExpense => amount < 0;
 
  String get initial => merchant.isNotEmpty ? merchant[0].toUpperCase() : '?';
 
  // ─────────────────────────────────────────
 
  String get formattedAmount {

    final abs = amount.abs().toStringAsFixed(2);

    return isExpense ? '-£$abs' : '+£$abs';

  }
 
  factory Transaction.fromJson(Map<String, dynamic> json) {

    return Transaction(

      id:          json['id'] as int,

      amount:      (json['amount'] as num).toDouble(),

      merchant:    json['merchant'] as String,

      description: json['description'] as String?,

      date:        DateTime.parse(json['date'] as String),

      source:      json['source'] as String? ?? 'manual',

      categoryId:  json['category_id'] as int?,

      createdAt:   json['created_at'] != null 
                     ? DateTime.parse(json['created_at'] as String)
                     : DateTime.now(),

    );

  }
 
  Map<String, dynamic> toJson() => {

    'amount':      amount,

    'merchant':    merchant,

    'description': description,

    'date':        date.toIso8601String(),

    'source':      source,

    'category_id': categoryId,

  };

}
 