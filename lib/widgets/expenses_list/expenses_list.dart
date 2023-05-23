import 'package:flutter/material.dart';
import 'package:third_app/widgets/expenses_list/expense_item.dart';

import '../../models/expense.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense expense) removeExpense;

  const ExpensesList(this.expenses, this.removeExpense, {super.key});

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
          margin: Theme.of(context).cardTheme.margin,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        onDismissed: (direction) {
          removeExpense(expenses[index]);
        },
        child: ExpenseItem(
          expenses[index],
        ),
      ),
    );
  }
}
