import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/transaction.dart';

class TransactionService {
  static const String _key = 'transactions';

  Future<List<Transaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_key);

    if (data == null || data.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(data);

    return decoded
        .map(
          (item) => Transaction.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<void> saveTransactions(
    List<Transaction> transactions,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final data = transactions
        .map((transaction) => transaction.toJson())
        .toList();

    await prefs.setString(
      _key,
      jsonEncode(data),
    );
  }
}