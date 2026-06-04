import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class TransactionService {
  // Use 10.0.2.2 for Android emulator (it maps to your machine's localhost)
  // Use localhost for iOS simulator or web
  static const String _base = 'http://10.0.2.2:8000';

  Future<List<Transaction>> getTransactions({int skip = 0, int limit = 50}) async {
    final uri = Uri.parse('$_base/transactions/?skip=$skip&limit=$limit');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions: ${response.statusCode}');
    }
  }
}