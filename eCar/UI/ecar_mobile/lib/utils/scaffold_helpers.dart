import 'package:flutter/material.dart';

class ScaffoldHelpers {
  static void showScaffold(context, text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )));
  }
}
