import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/request_screen.dart';
import 'package:ecar_mobile/screens/route_order_screen.dart';
import 'package:ecar_mobile/screens/vehicle_assigment_screen.dart';
import 'package:ecar_mobile/screens/notification_screen.dart';
import 'package:ecar_mobile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class MasterScreen extends StatefulWidget {
  String title;
  Widget child;
  MasterScreen(this.title, this.child, {super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  User? user = null;
  bool isLoading = true;
  int _currentPageIndex = 0;
  bool? isClient;
  final _storage = FlutterSecureStorage();
  late UserProvider userProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProvider = context.read<UserProvider>();
    _initForm();
  }

  Future _initForm() async {
    user = await userProvider.getUserFromToken();
    var role = await _storage.read(key: "role") ?? "";
    if (role == "client") {
      isClient = true;
    } else {
      isClient = false;
    }
    print("Client is: ${isClient.toString()}");
    print("Result: ${user?.userName}");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Pritisni")),
          )
        : _buildScafforld();
  }

  Widget _buildScafforld() {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: isClient!
            ? []
            : <Widget>[
                IconButton(
                  icon: const Icon(Icons.car_repair_sharp),
                  color: Colors.black,
                  padding: EdgeInsets.only(right: 90.0),
                  tooltip: "Pick up car",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VehicleAssigmentScreen(user: user),
                      ),
                    );
                  },
                )
              ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: isClient! ? _buildNavClient() : _buildNavDriver(),
      body: widget.child,
    );
  }

  Widget _buildNavClient() {
    return NavigationBar(
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_sharp),
          label: "Home",
        ),
        NavigationDestination(
            icon: Icon(Icons.date_range_rounded), label: "Order"),
        NavigationDestination(icon: Icon(Icons.car_rental), label: "Rent"),
        NavigationDestination(icon: Icon(Icons.stars_rounded), label: "Review"),
        NavigationDestination(icon: Icon(Icons.person_sharp), label: "Profile"),
      ],
      onDestinationSelected: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationScreen(false),
              ),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RouteOrderScreen(),
              ),
            );
            break;
          case 4:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );
            break;

          default:
            break;
        }
      },
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      backgroundColor: Colors.yellowAccent,
      indicatorColor: Colors.transparent,
    );
  }

  Widget _buildNavDriver() {
    return NavigationBar(
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_sharp),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.arrow_forward_outlined),
          label: "Requests",
        ),
        NavigationDestination(
          icon: Icon(Icons.car_rental),
          label: "Drives",
        ),
        NavigationDestination(
          icon: Icon(Icons.person_sharp),
          label: "Profile",
        ),
      ],
      onDestinationSelected: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationScreen(false),
              ),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RequestScreen(),
              ),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );
            break;

          default:
            break;
        }
      },
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      backgroundColor: Colors.yellowAccent,
      indicatorColor: Colors.transparent,
    );
  }
}
