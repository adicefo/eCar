import 'package:ecar_mobile/models/Driver/driver.dart';
import 'package:ecar_mobile/models/Route/route.dart' as Model;
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/driver_provider.dart';
import 'package:ecar_mobile/providers/route_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/drives_navigation_screen.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/utils/PointDTO/point_dto.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/getAddresLatLng_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:provider/provider.dart';

class DrivesScreen extends StatefulWidget {
  const DrivesScreen({super.key});

  @override
  State<DrivesScreen> createState() => _DrivesScreenState();
}

class _DrivesScreenState extends State<DrivesScreen> {
  User? user = null;
  Driver? d = null;

  SearchResult<Driver>? driver;
  SearchResult<Model.Route>? data;
  late RouteProvider routeProvider;
  late UserProvider userProvider;
  late DriverProvider driverProvider;

  bool isLoading = true;
  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    routeProvider = context.read<RouteProvider>();
    driverProvider = context.read<DriverProvider>();
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    try {
      user = await userProvider.getUserFromToken();
      var filterDriver = {"NameGTE": user?.name, "SurnameGTE": user?.surname};
      driver = await driverProvider.get(filter: filterDriver);

      d = driver?.result?.first;

      var filterRoute = {"Status": "active", "DriverId": d?.id};
      data = await routeProvider.get(filter: filterRoute);
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
        ? getisLoadingHelper()
        : MasterScreen(
            "Drives",
            SingleChildScrollView(
              child: _buildScreen(),
            ));
  }

  Widget _buildScreen() {
    return Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white),
          child: SizedBox(
              height: 400,
              width: double.infinity,
              child: Center(
                child: Image.asset(
                  fit: BoxFit.fill,
                  "assets/images/images (1).jpg",
                  height: 400,
                  width: 400,
                ),
              )),
        ),
        SizedBox(
          height: 10,
        ),
        buildHeader("Current drives"),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 300,
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, crossAxisSpacing: 10, childAspectRatio: 2.5),
            scrollDirection: Axis.vertical,
            children: _buildGridView(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildGridView() {
    if (data?.result?.length == 0) {
      return [
        Center(
            child: Text(
          "You do not have any drives now...",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ))
      ];
    }
    List<Widget> list = data!.result
        .map((x) => Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, strokeAlign: 1),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "User: ${x?.client?.user?.userName}" ?? "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                FutureBuilder<String>(
                  future: getAddressFromLatLng(LatLng(
                      latitude: x?.sourcePoint?.latitude ?? 0.0,
                      longitude: x?.sourcePoint?.longitude ?? 0.0)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Start point: Loading...");
                    } else if (snapshot.hasError) {
                      return Text("Start point: Error");
                    } else {
                      return Text(
                        "Start point: ${snapshot.data}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      );
                    }
                  },
                ),
                FutureBuilder<String>(
                  future: getAddressFromLatLng(LatLng(
                      latitude: x?.destinationPoint?.latitude ?? 0.0,
                      longitude: x?.destinationPoint?.longitude ?? 0.0)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("End point: Loading...");
                    } else if (snapshot.hasError) {
                      return Text("End point: Error");
                    } else {
                      return Text(
                        "End point: ${snapshot.data}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      );
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DrivesNavigationScreen(
                          object: x,
                        ),
                      ),
                    );
                  },
                  child: Text("Start drive"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                      foregroundColor: Colors.black,
                      minimumSize: Size(300, 30)),
                )
              ],
            )))
        .cast<Widget>()
        .toList();
    return list;
  }
}
