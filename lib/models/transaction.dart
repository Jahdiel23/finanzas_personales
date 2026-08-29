enum TransactionType {
  income,
  expense,
}

class Transaction {
  final int id;
  final String title;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'type': type.name,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      amount: (json['amount'] as num).toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      type: json['type'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
    );
  }
}