import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../services/transaction_service.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({
    super.key,
  });

  @override
  State<TransactionsScreen> createState() =>
      _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
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

  Future<void> addTransaction() async {
    final result =
        await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddTransactionScreen(),
      ),
    );

    if (result == null) {
      return;
    }

    final newTransaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch,
      title: result['title'],
      description: '',
      amount: result['amount'],
      category: result['category'],
      date: DateTime.now(),
      type: result['type'] == 'Ingreso'
          ? TransactionType.income
          : TransactionType.expense,
    );

    setState(() {
      transactions.add(newTransaction);
    });

    await transactionService.saveTransactions(
      transactions,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Movimiento guardado',
        ),
      ),
    );
  }

  Future<void> editTransaction(
    Transaction transaction,
  ) async {
    final result =
        await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddTransactionScreen(
          transactionData: {
            'title': transaction.title,
            'amount': transaction.amount,
            'category': transaction.category,
            'type':
                transaction.type == TransactionType.income
                    ? 'Ingreso'
                    : 'Gasto',
          },
        ),
      ),
    );

    if (result == null) {
      return;
    }

    final index = transactions.indexWhere(
      (item) => item.id == transaction.id,
    );

    if (index == -1) {
      return;
    }

    final updatedTransaction = Transaction(
      id: transaction.id,
      title: result['title'],
      description: transaction.description,
      amount: result['amount'],
      category: result['category'],
      date: transaction.date,
      type: result['type'] == 'Ingreso'
          ? TransactionType.income
          : TransactionType.expense,
    );

    setState(() {
      transactions[index] =
          updatedTransaction;
    });

    await transactionService.saveTransactions(
      transactions,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Movimiento actualizado',
        ),
      ),
    );
  }

  Future<void> deleteTransaction(
    Transaction transaction,
  ) async {
    setState(() {
      transactions.removeWhere(
        (item) =>
            item.id == transaction.id,
      );
    });

    await transactionService.saveTransactions(
      transactions,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Movimiento eliminado',
        ),
      ),
    );
  }

  void confirmDelete(
    Transaction transaction,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Eliminar movimiento',
          ),
          content: Text(
            '¿Deseas eliminar "${transaction.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);

                deleteTransaction(
                  transaction,
                );
              },
              child: const Text(
                'Eliminar',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movimientos',
        ),
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 70,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'No hay movimientos todavía',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Presiona + para agregar uno',
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadTransactions,
              child: ListView.builder(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                itemCount:
                    transactions.length,
                itemBuilder:
                    (context, index) {
                  final transaction =
                      transactions[index];

                  final isIncome =
                      transaction.type ==
                          TransactionType.income;

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: ListTile(
                      onTap: () {
                        editTransaction(
                          transaction,
                        );
                      },
                      leading:
                          CircleAvatar(
                        child: Icon(
                          isIncome
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                        ),
                      ),
                      title: Text(
                        transaction.title,
                      ),
                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.category,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Text(
                            '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              color: isIncome
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Editar',
                            onPressed: () {
                              editTransaction(
                                transaction,
                              );
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Eliminar',
                            onPressed: () {
                              confirmDelete(
                                transaction,
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: addTransaction,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}