import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ETransaction {
  static const String ID = "uid";
  static const String CATEGORY = "category";
  static const String USERID = "user_id";
  static const String TITLE = "title";
  static const String AMOUNT  = "amount";
  static const String DATE = "date";
  static const String CREATED = "created";

  String _uid;
  String _category;
  String _user_id;
  String _title;
  double _amount;
  String _date;
  DateTime _created;

  ETransaction(this._uid,this._category, this._user_id, this._title, this._amount, this._date, this._created);


  DateTime get created => _created;

  String get category => _category;

  String get date => _date;

  String get uid => _uid;

  String get user_id => _user_id;

  String get title => _title;

  double get amount => _amount;


  set created(DateTime value) {
    _created = value;
  }

  set date(String value) {
    _date = value;
  }
  set amount(double value) {
    _amount = value;
  }

  set title(String value) {
    _title = value;
  }

  set user_id(String value) {
    _user_id = value;
  }

  set uid(String value) {
    _uid = value;
  }

  set category(String value) {
    _category = value;
  }

  ETransaction.fromSnapshot(DocumentSnapshot snapshot){
  Map data = snapshot.data;
  _uid = snapshot.documentID;
  _category = snapshot.data[CATEGORY];
  _user_id = data[USERID];
  _title = data[TITLE];
  _amount = data[AMOUNT];
  _date = data[DATE];
 // _created = data[CREATED];
}

}
