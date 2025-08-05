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
        
        buildHeader("Current drives"),
        SizedBox(
          height: 10,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: _buildListView(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildListView() {
    if (data?.result?.length == 0) {
      return [
        Center(
          child:Padding(padding: EdgeInsets.only(top:100),
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_car_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "You do not have any drives now...",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),)
        )
      ];
    }
    List<Widget> list = data!.result
        .map((x) => Container(
              //height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, 
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(Icons.person, color: Colors.blueAccent),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "${x?.client?.user?.userName ?? 'Unknown User'}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 130, 
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.trip_origin,
                                color: Colors.green.shade800,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "From",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  FutureBuilder<String>(
                                    future: getAddressFromLatLng(LatLng(
                                        latitude: x?.sourcePoint?.latitude ?? 0.0,
                                        longitude: x?.sourcePoint?.longitude ?? 0.0)),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Text(
                                          "Loading...",
                                          style: TextStyle(fontSize: 14),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          "Error loading address",
                                          style: TextStyle(fontSize: 14, color: Colors.red),
                                        );
                                      } else {
                                        return Text(
                                          "${snapshot.data ?? 'Unknown location'}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Vertical line connector
                        Padding(
                          padding: EdgeInsets.only(left: 18),
                          child: Container(
                            height: 20,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red.shade800,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "To",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  FutureBuilder<String>(
                                    future: getAddressFromLatLng(LatLng(
                                        latitude: x?.destinationPoint?.latitude ?? 0.0,
                                        longitude: x?.destinationPoint?.longitude ?? 0.0)),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Text(
                                          "Loading...",
                                          style: TextStyle(fontSize: 14),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          "Error loading address",
                                          style: TextStyle(fontSize: 14, color: Colors.red),
                                        );
                                      } else {
                                        return Text(
                                          "${snapshot.data ?? 'Unknown location'}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.navigation),
                      label: Text("Start drive"),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellowAccent,
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .cast<Widget>()
        .toList();
    return list;
  }
}
