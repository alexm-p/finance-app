class Transaction {
  final int id;
  final double amount;
  final String merchant;
  final DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.merchant,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id:       json['id'],
      amount:   (json['amount'] as num).toDouble(),
      merchant: json['merchant'],
      date:     DateTime.parse(json['date']),
    );
  }
}