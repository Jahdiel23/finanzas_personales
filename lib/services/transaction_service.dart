import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class TransactionService {
  static const String baseUrl = 'http://10.0.2.2:8081/api/movimientos';

  Future<List<Transaction>> loadTransactions() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener movimientos: ${response.statusCode}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data.map((item) {
      return Transaction(
        id: (item['id'] as num).toInt(),
        title: item['titulo'] as String,
        description: item['descripcion'] ?? '',
        amount: (item['monto'] as num).toDouble(),
        category: item['categoria'] as String,
        date: DateTime.parse(item['fecha'] as String),
        type: item['tipo'] == 'INGRESO'
            ? TransactionType.income
            : TransactionType.expense,
      );
    }).toList();
  }

  Future<Transaction> createTransaction(
    Transaction transaction,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'titulo': transaction.title,
        'descripcion': transaction.description,
        'monto': transaction.amount,
        'categoria': transaction.category,
        'fecha': transaction.date
            .toIso8601String()
            .split('T')
            .first,
        'tipo': transaction.type == TransactionType.income
            ? 'INGRESO'
            : 'GASTO',
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Error al crear movimiento: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    return Transaction(
      id: (data['id'] as num).toInt(),
      title: data['titulo'] as String,
      description: data['descripcion'] ?? '',
      amount: (data['monto'] as num).toDouble(),
      category: data['categoria'] as String,
      date: DateTime.parse(data['fecha'] as String),
      type: data['tipo'] == 'INGRESO'
          ? TransactionType.income
          : TransactionType.expense,
    );
  }

  // Método para eliminar un movimiento por ID
  Future<void> deleteTransaction(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Error al eliminar el movimiento: ${response.statusCode}',
      );
    }
  }

  // NUEVO: Método para actualizar un movimiento existente por ID (PUT)
  Future<Transaction> updateTransaction(int id, Transaction transaction) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'titulo': transaction.title,
        'descripcion': transaction.description,
        'monto': transaction.amount,
        'categoria': transaction.category,
        'fecha': transaction.date
            .toIso8601String()
            .split('T')
            .first,
        'tipo': transaction.type == TransactionType.income
            ? 'INGRESO'
            : 'GASTO',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Error al actualizar el movimiento: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    return Transaction(
      id: (data['id'] as num).toInt(),
      title: data['titulo'] as String,
      description: data['descripcion'] ?? '',
      amount: (data['monto'] as num).toDouble(),
      category: data['categoria'] as String,
      date: DateTime.parse(data['fecha'] as String),
      type: data['tipo'] == 'INGRESO'
          ? TransactionType.income
          : TransactionType.expense,
    );
  }
}