import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category { food, travel, leisure, work }

final categoryVariable = {
  Category.food: Icons.lunch_dining_outlined,
  Category.leisure: Icons.movie_sharp,
  Category.travel: Icons.train,
  Category.work: Icons.laptop
};

class Expense {
  final String expenseId;
  final String expenseName;
  final double expenseAmount;
  final DateTime expenseDate;
  final Category category;

  Expense(
      {required this.expenseName,
      required this.expenseAmount,
      required this.expenseDate,
      required this.category})
      : expenseId = uuid.v4();

  String formatDate(DateTime date) {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  double get expensesSum {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.expenseAmount;
    }
    return sum;
  }
}
