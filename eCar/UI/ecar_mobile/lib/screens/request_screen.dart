import 'package:ecar_mobile/models/Driver/driver.dart';
import 'package:ecar_mobile/models/Request/request.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/driver_provider.dart';
import 'package:ecar_mobile/providers/request_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:ecar_mobile/utils/getAddresLatLng_helpers.dart';
import 'package:flutter/material.dart';
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
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    children: [
                      buildHeader("Your requests!"),
                      buildHeader("${user?.userName}"),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: _buildListView(),
                        ),
                      ),
                    ],
                  )),
            ));
  }

  List<Widget> _buildListView() {
    if (data?.result?.isEmpty == true) {
      return [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "You do not have any requests now...",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        )
      ];
    }
    
    List<Widget> list = data!.result.map<Widget>((x) => Container(
      height: 380,
      width: 300,
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
              color: Colors.amber,
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
                  child: Icon(Icons.person, color: Colors.amber),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "${x.route?.client?.user?.userName ?? 'Unknown User'}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  child: Image.asset(
                    "assets/images/no_image_placeholder.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            //height: 220,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    "ROUTE INFORMATION",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
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
                        size: 16,
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
                                latitude: x.route?.sourcePoint?.latitude ?? 0.0,
                                longitude: x.route?.sourcePoint?.longitude ?? 0.0)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text("Loading...", style: TextStyle(fontSize: 12));
                              } else if (snapshot.hasError) {
                                return Text("Error loading address", style: TextStyle(fontSize: 12, color: Colors.red));
                              } else {
                                return Text(
                                  "${snapshot.data ?? 'Unknown location'}",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
                  child: Container(height: 16, width: 2, color: Colors.grey.shade300),
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
                        size: 16,
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
                                latitude: x.route?.destinationPoint?.latitude ?? 0.0,
                                longitude: x.route?.destinationPoint?.longitude ?? 0.0)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text("Loading...", style: TextStyle(fontSize: 12));
                              } else if (snapshot.hasError) {
                                return Text("Error loading address", style: TextStyle(fontSize: 12, color: Colors.red));
                              } else {
                                return Text(
                                  "${snapshot.data ?? 'Unknown location'}",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
          
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  label: const Text("Reject"),
                  icon: const Icon(Icons.close),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.black,
                    minimumSize: Size(50, 50),
                  ),
                  onPressed: () async {
                    try {
                      var request = {"isAccepted": false};
                      await requestProvider.update(x.id, request);
                      ScaffoldHelpers.showScaffold(context, "Request rejected");
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RequestScreen()));
                    } catch (e) {
                      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                    }
                  },
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  label: const Text("Accept"),
                  icon: const Icon(Icons.check),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                    minimumSize: Size(30, 50),
                  ),
                  onPressed: () async {
                    try {
                      var request = {"isAccepted": true};
                      await requestProvider.update(x.id, request);
                      ScaffoldHelpers.showScaffold(context, "Request accepted");
                      _fetchRequest();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RequestScreen()));
                    } catch (e) {
                      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    )).toList();
    
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
