import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Category {
  static const String ID = "uid";
  static const String USERID = "user_id";
  static const String TITLE = "title";

  String _uid;
  String _user_id;
  String _title;


  Category(this._uid, this._user_id, this._title);


  Category.fromSnapshot(DocumentSnapshot snapshot){
    Map data = snapshot.data;
    _uid = snapshot.documentID;
    _user_id = data[USERID];
    _title = data[TITLE];
  }

  String get title => _title;

  String get user_id => _user_id;

  String get uid => _uid;

  set title(String value) {
    _title = value;
  }

  set user_id(String value) {
    _user_id = value;
  }

  set uid(String value) {
    _uid = value;
  }


}
