import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/transaction.dart';
import '../services/transaction_service.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transactionToEdit;

  const AddTransactionScreen({
    super.key,
    this.transactionToEdit,
  });

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final formKey = GlobalKey<FormState>();

  final TransactionService transactionService =
      TransactionService();

  String type = 'Gasto';

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();

  bool isSaving = false;

  bool get isEditing => widget.transactionToEdit != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final transaction = widget.transactionToEdit!;

      titleController.text = transaction.title;
      amountController.text = transaction.amount.toString();
      categoryController.text = transaction.category;
      type = transaction.type == TransactionType.income ? 'Ingreso' : 'Gasto';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    categoryController.dispose();

    super.dispose();
  }

  Future<void> saveTransaction() async {
    FocusScope.of(context).unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    final title = titleController.text.trim();
    final category = categoryController.text.trim();
    final amountText = amountController.text.trim().replaceAll(',', '.');
    final amount = double.parse(amountText);

    setState(() {
      isSaving = true;
    });

    try {
      if (isEditing) {
        // LÓGICA DE ACTUALIZACIÓN (PUT)
        final updatedTransaction = Transaction(
          id: widget.transactionToEdit!.id,
          title: title,
          description: widget.transactionToEdit!.description,
          amount: amount,
          category: category,
          date: widget.transactionToEdit!.date,
          type: type == 'Ingreso'
              ? TransactionType.income
              : TransactionType.expense,
        );

        await transactionService.updateTransaction(
          widget.transactionToEdit!.id!,
          updatedTransaction,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movimiento actualizado correctamente'),
          ),
        );
      } else {
        // LÓGICA DE CREACIÓN (POST)
        final newTransaction = Transaction(
          id: 0,
          title: title,
          description: '',
          amount: amount,
          category: category,
          date: DateTime.now(),
          type: type == 'Ingreso'
              ? TransactionType.income
              : TransactionType.expense,
        );

        await transactionService.createTransaction(newTransaction);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movimiento guardado correctamente'),
          ),
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar movimiento' : 'Nuevo movimiento',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.swap_vert),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Ingreso',
                      child: Text('Ingreso'),
                    ),
                    DropdownMenuItem(
                      value: 'Gasto',
                      child: Text('Gasto'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      type = value;
                    });
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: titleController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 40,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Ej. Comida',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Escribe un título';
                    }
                    if (value.trim().length < 2) {
                      return 'El título es demasiado corto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*[.,]?\d{0,2}'),
                    ),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                    hintText: '0.00',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Escribe un monto';
                    }
                    final text = value.trim().replaceAll(',', '.');
                    final amount = double.tryParse(text);
                    if (amount == null) {
                      return 'Escribe un monto válido';
                    }
                    if (amount <= 0) {
                      return 'El monto debe ser mayor que 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: categoryController,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    hintText: 'Ej. Comida, Transporte...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Escribe una categoría';
                    }
                    if (value.trim().length < 2) {
                      return 'La categoría es demasiado corta';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: isSaving ? null : saveTransaction,
                  icon: Icon(
                    isEditing ? Icons.save_outlined : Icons.add,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      isEditing ? 'Guardar cambios' : 'Guardar movimiento',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}