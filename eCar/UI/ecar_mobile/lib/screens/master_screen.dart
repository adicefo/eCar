import 'package:ecar_mobile/models/Driver/driver.dart';
import 'package:ecar_mobile/models/Statistics/statistics.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/auth_provider.dart';
import 'package:ecar_mobile/providers/driver_provider.dart';
import 'package:ecar_mobile/providers/statistics_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/drives_screen.dart';
import 'package:ecar_mobile/screens/rent_screen.dart';
import 'package:ecar_mobile/screens/request_screen.dart';
import 'package:ecar_mobile/screens/review_screen.dart';
import 'package:ecar_mobile/screens/route_order_screen.dart';
import 'package:ecar_mobile/screens/vehicle_assigment_screen.dart';
import 'package:ecar_mobile/screens/notification_screen.dart';
import 'package:ecar_mobile/screens/profile_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
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
  SearchResult<Driver>? driver;

  Statistics? statistics = null;

  bool isLoading = true;
  int _currentPageIndex = 0;
  bool? isClient;
  final _storage = FlutterSecureStorage();

  String? role = "";
  late AuthProvider authProvider;
  late UserProvider userProvider;
  late DriverProvider driverProvider;
  late StatisticsProvider statisticsProvider;

  @override
  void initState() {
    // TODO: implement initState
    authProvider = context.read<AuthProvider>();
    driverProvider = context.read<DriverProvider>();
    statisticsProvider = context.read<StatisticsProvider>();
    userProvider = context.read<UserProvider>();
    super.initState();
    _initForm();
  }

  Future _initForm() async {
    try {
      user = await userProvider.getUserFromToken();
      role = await _storage.read(key: "role") ?? "";
      if (role == "client") {
        isClient = true;
      } else {
        isClient = false;
      }
      if (role == "driver" && widget.title == "Profile") {
        _setStatisticsLogic();
      }

      print("Client is: ${isClient.toString()}");
      print("Result: ${user?.userName}");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
    }
  }

  Future _setStatisticsLogic() async {
    try {
      var filter = {"NameGTE": user?.name, "SurnameGTE": user?.surname};
      driver = await driverProvider.get(filter: filter);

      var d = driver?.result.first;

      var filterStat = {
        "DriverId": d?.id,
        "BeginningOfWork": DateTime.now().toIso8601String()
      };
      var stat = await statisticsProvider.get(filter: filterStat);

      statistics = stat?.result.firstWhere((x) => x.endOfWork == null);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
    }
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
         if (isClient! == false && widget.title != "Profile")
  Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: FloatingActionButton.extended(
        icon: Icon(Icons.directions_car),
        label: Text("Pick Up Car"),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VehicleAssigmentScreen(user: user),
            ),
          );
        },
      ),
    ),
  ),



          if (widget.title == "Profile")
            Padding(
              padding: EdgeInsets.only(right: 50),
              child: ElevatedButton.icon(
                onPressed: ()async{
if (statistics != null) {
                      try {
                        statistics = await statisticsProvider
                            .updateFinish(statistics?.id);
                      } catch (e) {
                        ScaffoldHelpers.showScaffold(
                            context, "${e.toString()}");
                      }
                    }
                    authProvider.logout(context);
                },
                
                icon: Icon(Icons.login),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    backgroundColor: Colors.yellowAccent,
                    foregroundColor: Colors.black,
                    minimumSize: Size(100, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              ),
            ),
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
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RentScreen(),
              ),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewScreen(),
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
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DrivesScreen(),
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
