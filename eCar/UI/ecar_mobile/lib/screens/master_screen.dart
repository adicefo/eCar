import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  String? clientOrDriver;
  MasterScreen({super.key, this.clientOrDriver});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Welcome ${widget.clientOrDriver}")),
    );
  }
}
