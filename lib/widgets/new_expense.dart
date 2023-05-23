import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:third_app/models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  final void Function(Expense expense) addExpense;

  const NewExpense(this.addExpense, {super.key});

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // var neseName = '';

  // void getEnteredText(String inputString) {
  //   newExpenseName = inputString;
  // }
  final expenseNameController = TextEditingController();
  final expenseAmountController = TextEditingController();
  DateTime? expenseDate;
  var expenseCategory = Category.food;

  @override
  void dispose() {
    expenseNameController.dispose();
    expenseAmountController.dispose();
    super.dispose();
  }

  void presentDatePicker() async {
    final now = DateTime.now();
    final earliestDate = DateTime(
        DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: earliestDate,
      lastDate: now,
    );
    setState(() {
      expenseDate = pickedDate;
    });
  }

  void submitExpenseData() {
    final enteredAmount = double.tryParse(expenseAmountController.text);
    final isAmountNull = enteredAmount == null;
    if (expenseNameController.text.isEmpty ||
        isAmountNull ||
        expenseDate == null) {
      print("Show OFF");
      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        // false = user must tap button, true = tap outside dialog
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: const Text('Invalid Entry'),
            content: const Text(
              'Please make sure correct Expense name, amount and date is entered..',
            ),
            actions: [
              TextButton(
                child: const Text('OKAY!'),
                onPressed: () {
                  Navigator.pop(ctx); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );
      return;
    } else {
      widget.addExpense(Expense(
          expenseName: expenseNameController.text,
          expenseAmount: enteredAmount,
          expenseDate: expenseDate!,
          category: expenseCategory));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(context) {
    var keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyBoardSpace + 16),
          child: Column(
            children: [
              TextField(
                controller: expenseNameController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Expense Name: "),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expenseAmountController,
                      decoration: const InputDecoration(
                        label: Text("Expense Amount: "),
                        prefix: Text("\u20B9 "),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          expenseDate == null
                              ? "No date selected"
                              : formatter.format(expenseDate!),
                        ),
                        IconButton(
                          onPressed: presentDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  DropdownButton(
                    value: expenseCategory,
                    items: Category.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        expenseCategory = value!;
                      });
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("cancel"),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: submitExpenseData,
                    child: const Text("Save Expense"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
