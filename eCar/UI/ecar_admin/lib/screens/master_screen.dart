import 'package:ecar_admin/main.dart';
import 'package:ecar_admin/models/CompanyPrice/companyPrice.dart';
import 'package:ecar_admin/providers/auth_provider.dart';
import 'package:ecar_admin/providers/companyPrice_provider.dart';
import 'package:ecar_admin/providers/user_provider.dart';
import 'package:ecar_admin/screens/admin_screen.dart';
import 'package:ecar_admin/screens/clients_screen.dart';
import 'package:ecar_admin/screens/company_prices_screen.dart';
import 'package:ecar_admin/screens/dashboard_screen.dart';
import 'package:ecar_admin/screens/driverVehicle_screen.dart';
import 'package:ecar_admin/screens/drivers_screen.dart';
import 'package:ecar_admin/screens/notification_screen.dart';
import 'package:ecar_admin/screens/rent_screen.dart';
import 'package:ecar_admin/screens/reports_screen.dart';
import 'package:ecar_admin/screens/review_screen.dart';
import 'package:ecar_admin/screens/routes_screen.dart';
import 'package:ecar_admin/screens/statistics_screen.dart';
import 'package:ecar_admin/screens/vehicle_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
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
  String currentRoute = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProvider = context.read<UserProvider>();
    authProvider = context.read<AuthProvider>();
    companyPriceProvider = context.read<CompanyPriceProvider>();
    initForm();

    // Set the current route based on the title
    currentRoute = widget.title;
  }

  Future initForm() async {
    try {
      user = await userProvider.getUserFromToken();
      price = await companyPriceProvider.getCurrentPrice();
      print("Retrived: ${user?.userName}");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
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
         
          SizedBox(
            width: 10,
          ),
          
        ],
      ),
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.yellowAccent,
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "@eCar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.yellowAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                          child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          "assets/images/65476-200.png",
                          height: 50,
                          width: 50,
                          color: Colors.black,
                        ),
                      )),
                      SizedBox(height: 8),
                      Center(
                          child: isLoading
                              ? Text("Loading user...",
                                  style: TextStyle(color: Colors.yellowAccent))
                              : Text(
                                  "${user?.userName}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellowAccent,
                                  ),
                                ))
                    ],
                  )),
              _buildNavItem(
                title: "Drivers",
                icon: Icons.drive_eta,
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => DriversListScreen()));
                },
                isActive: currentRoute == 'Drivers',
              ),
              _buildNavItem(
                title: "Clients",
                icon: Icons.people,
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ClientListScreen()));
                },
                isActive: currentRoute == 'Clients',
              ),
              _buildNavItem(
                title: "Routes",
                icon: Icons.route,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RouteListScreen()));
                },
                isActive: currentRoute == 'Routes',
              ),
              _buildNavItem(
                title: "Vehicles",
                icon: Icons.directions_car,
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => VehicleScreen()));
                },
                isActive: currentRoute == 'Vehicles',
              ),
              _buildNavItem(
                title: "Reviews",
                icon: Icons.rate_review,
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ReviewScreen()));
                },
                isActive: currentRoute == 'Reviews',
              ),
              _buildNavItem(
                title: "Notifications",
                icon: Icons.notifications,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NotificationScreen()));
                },
                isActive: currentRoute == 'Notifications',
              ),
              _buildNavItem(
                title: "Rents",
                icon: Icons.shopping_cart,
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RentScreen()));
                },
                isActive: currentRoute == 'Rent',
              ),
              Divider(color: Colors.black54, thickness: 1),
              MouseRegion(
                onEnter: (event) {
                  showMenu(
                    context: context,
                    color: Colors.yellowAccent,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    position: RelativeRect.fromLTRB(265, 350, 350, 0),
                    items: [
                      _buildPopupMenuItem(
                        title: "Admin",
                        icon: Icons.admin_panel_settings,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => AdminScreen()),
                        ),
                      ),
                      _buildPopupMenuItem(
                        title: "Statistics",
                        icon: Icons.bar_chart,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => StatisticsScreen()),
                        ),
                      ),
                       _buildPopupMenuItem(
                        title: "Company Prices",
                        icon: Icons.attach_money,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => CompanyPricesScreen()),
                        ),
                      ),
                      _buildPopupMenuItem(
                        title: "Driver Vehicles",
                        icon: Icons.directions_car,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => DriverVehicleScreen()),
                        ),
                      ),
                    ],
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.more_horiz, color: Colors.black),
                    title: Text(
                      "Additional",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_right, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 8,),
              _buildNavItem(
                 title: "Dashboard",
                icon: Icons.dashboard,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DashboardScreen()));
                },
                isActive: currentRoute == 'Dashboard',
              ),
              SizedBox(height: 8),
              _buildNavItem(
                title: "Log out",
                icon: Icons.logout,
                onTap: () {
                  authProvider.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false, // Remove all routes
                  );
                },
                isActive: false,
                isLogout: true,
              ),
            ],
          ),
        ),
      ),
      body: widget.child,
    );
  }

  Widget _buildNavItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isActive,
    bool isLogout = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.black
            : (isLogout ? Colors.red.withOpacity(0.1) : Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive
              ? Colors.yellowAccent
              : (isLogout ? Colors.red : Colors.black),
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive
                ? Colors.yellowAccent
                : (isLogout ? Colors.red : Colors.black),
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return PopupMenuItem(
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
      onTap: onTap,
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
          padding: MediaQuery.of(context).systemGestureInsets,
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 1000,
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
                            await AlertHelpers.addCompanyPriceConfirmation(context);
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
