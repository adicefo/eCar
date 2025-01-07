import 'package:ecar_admin/providers/user_provider.dart';
import 'package:ecar_admin/screens/clients_screen.dart';
import 'package:ecar_admin/screens/drivers_screen.dart';
import 'package:ecar_admin/screens/routes_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecar_admin/models/User/user.dart' as Model;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class MasterScreen extends StatefulWidget {
  MasterScreen(this.title, this.child, {super.key});
  String title;
  Widget child;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  Model.User? user = null;
  late UserProvider userProvider;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProvider = context.read<UserProvider>();
    initForm();
  }

  Future initForm() async {
    user = await userProvider.getUserFromToken();
    print("Retrived: ${user?.userName}");
    setState(() {
      isLoading = false;
    });
  }

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
                Center(
                    child: isLoading
                        ? Text("Username")
                        : Text("${user?.userName}"))
              ],
            )),
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
            ),
            ListTile(
              title: Text("Vehicles"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RouteListScreen()));
              },
            ),
            ListTile(
              title: Text("Reviews"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RouteListScreen()));
              },
            ),
            ListTile(
              title: Text("Notifications"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RouteListScreen()));
              },
            ),
            ListTile(
              title: Text("Rents"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RouteListScreen()));
              },
            ),
            ListTile(
              title: Text("Log out"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: widget.child,
    );
  }
}
