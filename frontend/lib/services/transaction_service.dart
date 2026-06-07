// lib/services/transaction_service.dart
// ─────────────────────────────────────────────────────
// All HTTP calls to /transactions live here.
// Screens never call http.get directly — they go through
// this service so the API logic is in one place.
// ─────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class TransactionService {
  // 10.0.2.2 maps to your machine's localhost on Android emulator.
  // Change to 'localhost' for iOS simulator or web.
  static const String _base = 'http://127.0.0.1:8000';

  // GET /transactions/ — paginated, newest first
  Future<List<Transaction>> getTransactions({
    int skip = 0,
    int limit = 50,
  }) async {
    final uri = Uri.parse('$_base/transactions/?skip=$skip&limit=$limit');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Failed to load transactions (${response.statusCode})');
    }
  }

  // POST /transactions/ — manually add a transaction
  Future<Transaction> createTransaction({
    required double amount,
    required String merchant,
    String? description,
    required DateTime date,
    int? categoryId,
  }) async {
    final uri = Uri.parse('$_base/transactions/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'merchant': merchant,
        'description': description,
        'date': date.toIso8601String(),
        'source': 'manual',
        'category_id': categoryId,
      }),
    );

    if (response.statusCode == 201) {
      return Transaction.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception(
          'Failed to create transaction (${response.statusCode})');
    }
  }

  // DELETE /transactions/:id
  Future<void> deleteTransaction(int id) async {
    final uri = Uri.parse('$_base/transactions/$id');
    final response = await http.delete(uri);

    if (response.statusCode != 204) {
      throw Exception(
          'Failed to delete transaction (${response.statusCode})');
    }
  }
}
