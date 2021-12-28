import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return; // Stops the function execution
    }

    widget.addTx(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop(); // video 94
  }

  void _presentDatePicker() {
    // To show a date picker
    showDatePicker(
            // Used to pick date
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                10, // for the bottom of that model sheet
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                  // TextFeild gets input from user
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData()),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType
                    .number, // Use this to get number only keyboard --- ****important****
                onSubmitted: (_) =>
                    _submitData(), // Here _ mean that we are getting a argument but we are not using it. we just put it there so that we don't get any errors
              ),
              Row(
                children: <Widget>[
                  Text(_selectedDate == null
                      ? 'No date chosen!'
                      : 'Picked date : ${DateFormat.yMd().format(_selectedDate)}'),
                  Platform.isIOS
                      ? CupertinoButton(
                          onPressed: _presentDatePicker,
                          child: Text(
                            'Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : FlatButton(
                          onPressed: _presentDatePicker,
                          child: Text(
                            'Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          textColor: Colors.purple,
                        ),
                ],
              ),
              RaisedButton(
                color: Colors.purple,
                child: Text(
                  'Add Transaction',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textColor: Colors.white,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
