import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);   ---- We are setting that the app can only be in potrait mode(up and down) and it Can't be in landscape mode. this is one solution of the landscape problem.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily:
            'Quicksand', // Changes the theme of the app --- Very important
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // Transactions data(Next step is to map this data to widget)

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String titleInput;

  String amountInput;

  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((element) {
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    // We will create a object for transaction class and we will add that object to list of transactions(userTransactions)
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: chosenDate,
    );
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    // Will show the pop up from bottom ahen we click + button to add new transaction
    showModalBottomSheet(
        // Shows a model sheet from bottom
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Show Chart'),
          Switch.adaptive(
              // here adaptive is used so that the switch theme can change automatically for android and ios
              // Creates a slider switch which allows the user to change something
              value: _showChart,
              onChanged: (val) {
                // Here val will be true when the user presses the slider otherwise it will be false
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
      _showChart
          ? Container(
              child: Chart(_recentTransactions),
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7, // To make our app responsive for all devices with different screen sizes--- here height*0.6 means 60% of the availabe height
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPotraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        child: Chart(_recentTransactions),
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.3, // To make our app responsive for all devices with different screen sizes--- here height*0.6 means 60% of the availabe height
      ),
      txListWidget
    ];
  }

  Widget _iosBar() {
    return CupertinoNavigationBar(
      middle: Text(
        'Personal Expenses',
        style: TextStyle(fontFamily: 'Open Sans'),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context),
          )
        ],
      ),
    );
  }

  Widget _androidBar() {
    return AppBar(
      title: const Text(
        'Personal Expenses',
        style: TextStyle(fontFamily: 'Open Sans'),
      ),
      actions: <Widget>[
        // For the + button on the top right corner
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar =
        Platform.isIOS ? _iosBar() : _androidBar();

    final txListWidget = Container(
      child: TransactionList(_userTransaction, _deleteTransaction),
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7, // Here we are calculating the total available height by subracting the total height of the screen - height of the appbar - height of the status bar(padding at the top) and we are multiply 0.6 so that the list view can take the remaining 60% of the available height
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        // To scroll if the list exceeds the size of the window
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandScape)
              ..._buildLandscapeContent(
                  MediaQuery.of(context), appBar, txListWidget),
            if (!isLandScape)
              ..._buildPotraitContent(MediaQuery.of(context), appBar,
                  txListWidget), // The ... here tells dart that it should merge all the 2 widgets that are returned into a single one
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody, navigationBar: appBar)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation: FloatingActionButtonLocation
                .centerFloat, // Adds the plus button on bottom
            floatingActionButton: Platform
                    .isIOS // We are checking whether the platform is ios or not. if it's ios then we are just printing a empty container. if it's not ios then we are printing that '+' button
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
