import 'package:flutter/material.dart';

Widget buildHeader(String content) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Column(
      children: [
        Align(
            alignment: Alignment.center,
            child: Text(
              "${content}",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            )),
      ],
    ),
  );
}
