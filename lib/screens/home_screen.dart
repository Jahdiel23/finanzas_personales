import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../services/transaction_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              transaction.type == TransactionType.income,
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
              transaction.type == TransactionType.expense,
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

  List<Transaction> get recentTransactions {
    final copy = [...transactions];

    copy.sort(
      (a, b) => b.date.compareTo(a.date),
    );

    return copy.take(5).toList();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Finanzas',
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
              'Saldo disponible',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              formatMoney(balance),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: balance >= 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Ingresos',
                    amount: totalIncome,
                    icon: Icons.arrow_upward,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildSummaryCard(
                    title: 'Gastos',
                    amount: totalExpense,
                    icon: Icons.arrow_downward,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Últimos movimientos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  '${transactions.length} en total',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (recentTransactions.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 12),

                      Text(
                        'No hay movimientos todavía',
                      ),
                    ],
                  ),
                ),
              )
            else
              ...recentTransactions.map(
                (transaction) {
                  final isIncome =
                      transaction.type ==
                          TransactionType.income;

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),

                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),

                      leading: CircleAvatar(
                        child: Icon(
                          isIncome
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                        ),
                      ),

                      title: Text(
                        transaction.title,
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.category,
                          ),

                          const SizedBox(height: 2),

                          Text(
                            '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                          ),
                        ],
                      ),

                      trailing: Text(
                        '${isIncome ? '+' : '-'}${formatMoney(transaction.amount)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isIncome
                              ? Colors.green
                              : Colors.red,
                        ),
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
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            CircleAvatar(
              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 6),

            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatMoney(amount),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}