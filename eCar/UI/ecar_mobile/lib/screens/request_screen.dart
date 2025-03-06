import 'package:ecar_mobile/models/Driver/driver.dart';
import 'package:ecar_mobile/models/Request/request.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/driver_provider.dart';
import 'package:ecar_mobile/providers/request_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/utils/PointDTO/point_dto.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/getAddresLatLng_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:provider/provider.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  User? user = null;
  Driver? d = null;

  SearchResult<Request>? data;
  SearchResult<Driver>? driverResult;

  late UserProvider userProvider;
  late DriverProvider driverProvider;
  late RequestProvider requestProvider;

  bool isLoading = true;

  @override
  void initState() {
    requestProvider = context.read<RequestProvider>();
    userProvider = context.read<UserProvider>();
    driverProvider = context.read<DriverProvider>();
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    try {
      user = await userProvider.getUserFromToken();
      var filterDriver = {"NameGTE": user?.name, "SurnameGTE": user?.surname};
      driverResult = await driverProvider.get(filter: filterDriver);
      //taking only one from SearchResult
      var d = driverResult?.result.first;

      var filterRequest = {"DriverId": d?.id};
      data = await requestProvider.get(filter: filterRequest);

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
            "Request",
            SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    children: [
                      buildHeader("Your requests!\n   ${user?.userName}"),
                      Container(
                        height: 500,
                        child: GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 2.5),
                          scrollDirection: Axis.vertical,
                          children: _buildGridView(),
                        ),
                      ),
                    ],
                  )),
            ));
  }

  List<Widget> _buildGridView() {
    if (data?.result?.length == 0) {
      return [Text("You do not have any requests now...")];
    }
    List<Widget> list = data!.result
        .map((x) => Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, strokeAlign: 1),
                borderRadius: BorderRadius.zero,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "User: ${x?.route?.client?.user?.userName}" ?? "",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          FutureBuilder<String>(
                            future: getAddressFromLatLng(LatLng(
                                latitude:
                                    x?.route?.sourcePoint?.latitude ?? 0.0,
                                longitude:
                                    x?.route?.sourcePoint?.longitude ?? 0.0)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("Start point: Loading...");
                              } else if (snapshot.hasError) {
                                return Text("Start point: Error");
                              } else {
                                return Text(
                                  "Start point: ${snapshot.data}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                );
                              }
                            },
                          ),
                          FutureBuilder<String>(
                            future: getAddressFromLatLng(LatLng(
                                latitude:
                                    x?.route?.destinationPoint?.latitude ?? 0.0,
                                longitude:
                                    x?.route?.destinationPoint?.longitude ??
                                        0.0)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text("End point: Loading...");
                              } else if (snapshot.hasError) {
                                return Text("End point: Error");
                              } else {
                                return Text(
                                  "End point: ${snapshot.data}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Image.asset(
                            "assets/images/no_image_placeholder.png",
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            var request = {"isAccepted": false};
                            await requestProvider.update(x.id, request);
                            ScaffoldHelpers.showScaffold(
                                context, "Request rejected");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestScreen(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldHelpers.showScaffold(
                                context, "${e.toString()}");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.black,
                          minimumSize: Size(50, 50),
                        ),
                        child: const Text("Reject"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            var request = {"isAccepted": true};
                            await requestProvider.update(x.id, request);
                            ScaffoldHelpers.showScaffold(
                                context, "Request accepted");
                            _fetchRequest();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RequestScreen(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldHelpers.showScaffold(
                                context, "${e.toString()}");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.black,
                          minimumSize: Size(50, 50),
                        ),
                        child: const Text("Accept"),
                      ),
                    ],
                  ),
                ],
              ),
            ))
        .cast<Widget>()
        .toList();
    return list;
  }

  Future<void> _fetchRequest() async {
    try {
      var filterRequest = {"DriverId": d?.id};
      data = await requestProvider.get(filter: filterRequest);
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
    }
  }
}
