import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'package:intl/intl.dart';

class transaction_item extends StatelessWidget {
  const transaction_item({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final transaction;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        // Column of lists
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(child: Text('\$${transaction.amount}')),
          ),
        ),
        title: Text(
          transaction.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: MediaQuery.of(context).size.width >
                460 // Here we are checking whether the width of the device is more than 460. if it's greater than 460 then we also display delete text with symbol.
            ? FlatButton.icon(
                textColor: Colors.red,
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                onPressed: () => deleteTx(transaction.id),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () => deleteTx(transaction.id),
              ),
      ),
    );
  }
}
