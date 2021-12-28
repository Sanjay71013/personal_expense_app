import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraint) {
            return Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ), // empty space(Box in shape, has height and width)
                Container(
                    height: constraint.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit
                          .cover, // ****Important**** --- fits the image completely in the window
                    )),
              ],
            );
          })
        : ListView.builder(
            // List view is always scrollable
            itemBuilder: (context, index) {
              return transaction_item(
                  transaction: transactions[index], deleteTx: deleteTx);
            },
            itemCount: transactions
                .length, // Dosen't have a fixed height. Has infinite height. It uses scrolling feature.
          );
  }
}
