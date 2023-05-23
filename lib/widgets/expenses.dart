import 'package:flutter/material.dart';
import 'package:third_app/chart/chart.dart';
import 'package:third_app/models/expense.dart';
import 'package:third_app/widgets/expenses_list/expenses_list.dart';

import 'new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> registeredExpenses = [
    Expense(
        expenseName: 'Mess Card',
        expenseAmount: 805,
        expenseDate: DateTime.now(),
        category: Category.food),
    Expense(
        expenseName: 'Laundry',
        expenseAmount: 295,
        expenseDate: DateTime.now(),
        category: Category.leisure),
    Expense(
        expenseName: 'Calculator',
        expenseAmount: 550,
        expenseDate: DateTime.now(),
        category: Category.work),
  ];

  void addNewExpense(Expense expense) {
    setState(() {
      registeredExpenses.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    final expenseIndex = registeredExpenses.indexOf(expense);
    setState(() {
      registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: const Text("Expense deleted!"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  void openModelOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true, //to make show model Bottom Sheet in full Screen
      context: context,
      builder: (ctx) => NewExpense(addNewExpense),
    );
  }

  @override
  Widget build(context) {
    var width = MediaQuery.of(context).size.width;
    print(width);
    var height = MediaQuery.of(context).size.height;
    print(height);
    Widget mainContent =
        const Center(child: Text("No Expense found, try adding Some!!"));
    if (registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        registeredExpenses,
        removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: openModelOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Center(
        child: width < 600
            ? Column(
                children: [
                  Chart(expenses: registeredExpenses),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Chart(expenses: registeredExpenses),
                  ),
                  Expanded(
                    child: mainContent,
                  ),
                ],
              ),
      ),
    );
  }
}
