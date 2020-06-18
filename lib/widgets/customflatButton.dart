import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final String text;
  final Function handler;

  const CustomFlatButton({Key key, this.text, this.handler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: handler,
    )
        : FlatButton(
      textColor: Theme.of(context).primaryColor,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.deepOrange,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: handler,
    );
  }
}
