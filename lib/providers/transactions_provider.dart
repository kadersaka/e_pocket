
import 'package:epocket/controllers/transactionscontroller.dart';
import 'package:epocket/models/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionsProvider with ChangeNotifier{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ETransaction> transactions_list = [];
  TransactionsController _transactionsController = TransactionsController();
  TransactionsProvider(){
    getTransactions();
  }

  Future getTransactions()async{
    FirebaseUser user = await _auth.currentUser();
    print("============== user.uid: ${user.uid}");

    transactions_list = await _transactionsController.getETransactionByUser(user.uid);
    print("============== transactions_list: $transactions_list");
    notifyListeners();
  }
}