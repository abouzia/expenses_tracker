import 'package:expenses_tracker/widgets/charts/chart.dart';
import 'package:expenses_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expenses_tracker/models/expense.dart';
import 'package:expenses_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _expensesList = [
    Expense(
      title: 'Flutter course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Pasticio',
      amount: 3.5,
      date: DateTime.now(),
      category: Category.food,
    ),
  ];

  _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expensesList.add(expense);
    });
  }

  void _deleteExpense(Expense expense) {
    final expenseIndex = _expensesList.indexOf(expense);
    setState(() {
      _expensesList.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _expensesList.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Center(
        child: width < 600
            ? Column(
                children: [
                  Chart(expenses: _expensesList),
                  Expanded(
                    child: ExpensesList(
                      expenses: _expensesList,
                      onDeleteExpense: _deleteExpense,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _expensesList)),
                  Expanded(
                    child: ExpensesList(
                      expenses: _expensesList,
                      onDeleteExpense: _deleteExpense,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
