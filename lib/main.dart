import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() { 
  // to set Orientation Manually;
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown
  //   ]
  // );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          // errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }
  AppBar _appBar = AppBar(
        title: Text(
          'Personal Expenses',
        ),actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => null,
          ),
        ],
        );

  bool showChart = false;
  
  @override
  Widget build(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    return Scaffold(
      appBar: _appBar,
      
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // this is for Portrait Mode:
            if(!isLandscape)
            Container(height: (mediaQuery.size.height - _appBar.preferredSize.height 
            - mediaQuery.padding.top)*.3,
            child: Chart(_recentTransactions)),
            if(!isLandscape)
            Container(height: (mediaQuery.size.height - _appBar.preferredSize.height 
            - mediaQuery.padding.top)*.7, 
            child: TransactionList(_userTransactions, _deleteTransaction)),
          
          // this is  for Landscape mode:
          if(isLandscape)
            Row( children: 
              [Text("show chart"), Switch(onChanged:(val){ setState(() {
                showChart = val;
              });} , value: showChart,)
              ]
            ),
          if(isLandscape)
            showChart==true? Container(height: (mediaQuery.size.height - _appBar.preferredSize.height 
            - mediaQuery.padding.top)*.7,
            child: Chart(_recentTransactions))
            : Container(height: (mediaQuery.size.height - _appBar.preferredSize.height 
            - mediaQuery.padding.top)*.7, 
            child: TransactionList(_userTransactions, _deleteTransaction)),
          
          
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS? Container(): FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
