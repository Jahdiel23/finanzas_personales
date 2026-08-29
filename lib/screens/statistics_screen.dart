import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../services/transaction_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() =>
      _StatisticsScreenState();
}

class _StatisticsScreenState
    extends State<StatisticsScreen> {
  final TransactionService transactionService =
      TransactionService();

  List<Transaction> transactions = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final savedTransactions =
        await transactionService.loadTransactions();

    if (!mounted) {
      return;
    }

    setState(() {
      transactions = savedTransactions;
      isLoading = false;
    });
  }

  double get totalIncome {
    return transactions
        .where(
          (transaction) =>
              transaction.type ==
              TransactionType.income,
        )
        .fold(
          0,
          (total, transaction) =>
              total + transaction.amount,
        );
  }

  double get totalExpense {
    return transactions
        .where(
          (transaction) =>
              transaction.type ==
              TransactionType.expense,
        )
        .fold(
          0,
          (total, transaction) =>
              total + transaction.amount,
        );
  }

  double get balance {
    return totalIncome - totalExpense;
  }

  Map<String, double> get expensesByCategory {
    final Map<String, double> result = {};

    for (final transaction in transactions) {
      if (transaction.type ==
          TransactionType.expense) {
        result[transaction.category] =
            (result[transaction.category] ?? 0) +
                transaction.amount;
      }
    }

    return result;
  }

  String formatMoney(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final categories =
        expensesByCategory.entries.toList();

    categories.sort(
      (a, b) => b.value.compareTo(a.value),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estadísticas',
        ),
      ),

      body: RefreshIndicator(
        onRefresh: loadTransactions,

        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),

          children: [
            const Text(
              'Resumen financiero',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _buildSummaryCard(
              title: 'Ingresos',
              amount: totalIncome,
              icon: Icons.arrow_upward,
              color: Colors.green,
            ),

            const SizedBox(height: 12),

            _buildSummaryCard(
              title: 'Gastos',
              amount: totalExpense,
              icon: Icons.arrow_downward,
              color: Colors.red,
            ),

            const SizedBox(height: 12),

            _buildSummaryCard(
              title: 'Saldo',
              amount: balance,
              icon:
                  Icons.account_balance_wallet_outlined,
              color: balance >= 0
                  ? Colors.blue
                  : Colors.red,
            ),

            const SizedBox(height: 30),

            const Text(
              'Gastos por categoría',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            if (categories.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Icon(
                        Icons.bar_chart_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 12),

                      Text(
                        'No hay gastos registrados',
                      ),
                    ],
                  ),
                ),
              )
            else
              ...categories.map(
                (category) {
                  final percentage =
                      totalExpense == 0
                          ? 0.0
                          : category.value /
                              totalExpense;

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                child: Icon(
                                  Icons
                                      .category_outlined,
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: Text(
                                  category.key,
                                  style:
                                      const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                              Text(
                                formatMoney(
                                  category.value,
                                ),
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          LinearProgressIndicator(
                            value: percentage,
                            minHeight: 9,
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            '${(percentage * 100).toStringAsFixed(1)}% de tus gastos',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        leading: CircleAvatar(
          child: Icon(
            icon,
            color: color,
          ),
        ),

        title: Text(
          title,
        ),

        trailing: Text(
          formatMoney(amount),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}