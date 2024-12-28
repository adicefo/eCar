import 'package:ecar_admin/screens/clients_screen.dart';
import 'package:ecar_admin/screens/drivers_screen.dart';
import 'package:ecar_admin/screens/routes_screen.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  MasterScreen({super.key});
  String? title;
  Widget? child;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("@username"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.yellowAccent,
        child: ListView(
          children: [
            ListTile(
              title: Text("Back"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Drivers"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => DriversListScreen()));
              },
            ),
            ListTile(
              title: Text("Clients"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ClientListScreen()));
              },
            ),
            ListTile(
              title: Text("Routes"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RouteListScreen()));
              },
            )
          ],
        ),
      ),
      body: widget.child,
    );
  }
}
