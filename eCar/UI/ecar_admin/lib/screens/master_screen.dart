import 'package:ecar_admin/main.dart';
import 'package:ecar_admin/models/CompanyPrice/companyPrice.dart';
import 'package:ecar_admin/providers/auth_provider.dart';
import 'package:ecar_admin/providers/companyPrice_provider.dart';
import 'package:ecar_admin/providers/user_provider.dart';
import 'package:ecar_admin/screens/clients_screen.dart';
import 'package:ecar_admin/screens/drivers_screen.dart';
import 'package:ecar_admin/screens/notification_screen.dart';
import 'package:ecar_admin/screens/rent_screen.dart';
import 'package:ecar_admin/screens/reports_screen.dart';
import 'package:ecar_admin/screens/review_screen.dart';
import 'package:ecar_admin/screens/routes_screen.dart';
import 'package:ecar_admin/screens/vehicle_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:flutter/cupertino.dart';
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
  CompanyPrice? price = null;
  late UserProvider userProvider;
  late AuthProvider authProvider;
  late CompanyPriceProvider companyPriceProvider;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProvider = context.read<UserProvider>();
    authProvider = context.read<AuthProvider>();
    companyPriceProvider = context.read<CompanyPriceProvider>();
    initForm();
  }

  Future initForm() async {
    user = await userProvider.getUserFromToken();
    price = await companyPriceProvider.getCurrentPrice();
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
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ReportsScreen()));
            },
            child: Text("Report"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: Size(50, 50),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            icon: const Icon(Icons.monetization_on),
            padding: EdgeInsets.only(right: 90.0),
            tooltip: "Change price",
            onPressed: () {
              _showModal(context);
            },
          )
        ],
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
              hoverColor: Color.fromRGBO(255, 255, 255, 0.87),
            ),
            ListTile(
              title: Text("Clients"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ClientListScreen()));
              },
              hoverColor: Color.fromRGBO(255, 255, 255, 0.87),
            ),
            ListTile(
              title: Text("Routes"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RouteListScreen()));
              },
              hoverColor: Color.fromRGBO(255, 255, 255, 0.87),
            ),
            ListTile(
              title: Text("Vehicles"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => VehicleScreen()));
              },
              hoverColor: Color.fromRGBO(255, 255, 255, 0.87),
            ),
            ListTile(
              title: Text("Reviews"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ReviewScreen()));
              },
              hoverColor: Color.fromRGBO(255, 255, 255, 0.87),
            ),
            ListTile(
              title: Text("Notifications"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationScreen()));
              },
              hoverColor: Color.fromRGBO(255, 255, 255, 0.87),
            ),
            ListTile(
              title: Text("Rents"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RentScreen()));
              },
              hoverColor: Color.fromRGBO(255, 255, 255, 0.87),
            ),
            ListTile(
              title: Text("Log out"),
              onTap: () {
                authProvider.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false, // Remove all routes
                );
              },
              hoverColor: Color.fromRGBO(255, 255, 255, 0.87),
            )
          ],
        ),
      ),
      body: widget.child,
    );
  }

  void _showModal(BuildContext context) {
    final TextEditingController fulfilledController = TextEditingController(
        text: "${price?.pricePerKilometar.toString()} KM");
    final TextEditingController userInputController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.yellowAccent,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context)
              .systemGestureInsets, // For proper keyboard handling
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 1000, // Set a specific height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change price per kilometar',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Align(
                    alignment: Alignment.centerRight,
                    child: TextField(
                      controller: fulfilledController,
                      decoration: InputDecoration(
                        labelText: 'Current price',
                        hintText: 'Current price per kilometar of drive',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      style: TextStyle(fontSize: 24),
                      enabled: true,
                    )),
                SizedBox(height: 10),
                TextField(
                  controller: userInputController,
                  decoration: InputDecoration(
                    labelText: 'New price',
                    hintText: 'Enter new price for company...',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: TextStyle(fontSize: 24),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final result = {
                          "pricePerKilometar":
                              double.tryParse(userInputController.text),
                        };
                        if (result['pricePerKilometar'] == null) {
                          AlertHelpers.showAlert(context, "Invalid value",
                              "Please enter valid numerical value");
                          return;
                        }
                        bool? confirmEdit =
                            await AlertHelpers.editConfirmation(context);
                        if (confirmEdit == true) {
                          companyPriceProvider.insert(result);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.lightGreen,
                                  content: Text(
                                    'Successful new price has been set',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )));
                          Navigator.of(context).pop();
                          initForm();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
