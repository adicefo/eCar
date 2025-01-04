import 'package:ecar_admin/screens/clients_screen.dart';
import 'package:ecar_admin/screens/drivers_screen.dart';
import 'package:ecar_admin/screens/routes_screen.dart';
import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  MasterScreen(this.title, this.child, {super.key});
  String title;
  Widget child;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent,
      ),
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.yellowAccent,
        child: ListView(
          children: [
            DrawerHeader(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "@ eCar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Center(
                    child: Image.asset(
                  "assets/images/65476-200.png",
                  height: 70,
                  width: 70,
                )),
                //TODO:Get username from token
                Center(child: Text("Username"))
              ],
            )),
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
