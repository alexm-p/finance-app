import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scheduled_payment.dart';

class ScheduledPaymentService {
  static const String _base = 'http://localhost:8000';

  Future<List<ScheduledPayment>> getScheduledPayments({
    int skip = 0,
    int limit = 50,
  }) async {
    final uri = Uri.parse('$_base/scheduled_payments/?skip=$skip&limit=$limit');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => ScheduledPayment.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load scheduled payments (${response.statusCode})');
    }
  }

  Future<ScheduledPayment> createScheduledPayment({
    required String name,
    required double amount,
    required String frequency,
    required DateTime nextDue,
    int? categoryId,
  }) async {
    final uri = Uri.parse('$_base/scheduled_payments/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name':        name,
        'amount':      amount,
        'frequency':   frequency,
        'next_due':    nextDue.toIso8601String(),
        'category_id': categoryId,
        'is_active':   true,
      }),
    );

    if (response.statusCode == 201) {
      return ScheduledPayment.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create scheduled payment (${response.statusCode})');
    }
  }

  Future<void> deleteScheduledPayment(int id) async {
    final uri = Uri.parse('$_base/scheduled_payments/$id');
    final response = await http.delete(uri);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete scheduled payment (${response.statusCode})');
    }
  }
}