import 'package:ecar_mobile/models/Rent/rent.dart';
import 'package:ecar_mobile/models/Route/route.dart' as Model;
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/rent_provider.dart';
import 'package:ecar_mobile/providers/route_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/profile_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/getAddresLatLng_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:ecar_mobile/utils/string_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:provider/provider.dart';

class ProfileArchiveScreen extends StatefulWidget {
  User? user;
  String? role;
  ProfileArchiveScreen({super.key, this.user, this.role});

  @override
  State<ProfileArchiveScreen> createState() => _ProfileArchiveScreenState();
}

class _ProfileArchiveScreenState extends State<ProfileArchiveScreen> {
  SearchResult<Model.Route>? routes;
  SearchResult<Rent>? rents;

  late RouteProvider routeProvider;
  late RentProvider rentProvider;

  bool isLoading = true;
  bool isRoute = true;
  @override
  void initState() {
    routeProvider = context.read<RouteProvider>();
    rentProvider = context.read<RentProvider>();
    super.initState();

    _initForm();
  }

  void _initForm() async {
    try {
      var filterRoute = {"Status": "finished", "UserId": widget?.user?.id};
      routes = await routeProvider.get(filter: filterRoute);
      if (widget?.role == "client") {
        var filterRent = {"Status": "finished", "UserId": widget?.user?.id};
        rents = await rentProvider.get(filter: filterRent);
      }
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
        : MasterScreen("Profile", _buildScreen());
  }

  Widget _buildScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildHeader("Archive"),
          Container(
            height: 500,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.5),
              scrollDirection: Axis.vertical,
              children: _buildGridView(),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          if (widget?.role == "client") _buildFooter(),
          if (widget?.role == "driver") _buildBackBtn()
        ],
      ),
    );
  }

  List<Widget> _buildGridView() {
    if (isRoute) {
      if (routes?.result?.length == 0) {
        return [Text("Sorry there is no routes in archive")];
      }
      List<Widget> listRoutes = routes!.result
          .map(
            (x) => GestureDetector(
                onTap: () {},
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(color: Colors.black, strokeAlign: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.role == "driver"
                                    ? x?.client?.image != null
                                        ? Container(
                                            width: 80,
                                            height: 80,
                                            child: StringHelpers
                                                .imageFromBase64String(
                                                    x.client!.image!),
                                          )
                                        : Container(
                                            width: 80,
                                            height: 80,
                                            child: Image.asset(
                                              "assets/images/no_image_placeholder.png",
                                              height: 80,
                                              width: 80,
                                            ),
                                          )
                                    : Icon(Icons.person, size: 80),
                                SizedBox(height: 8),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    widget.role == "driver"
                                        ? "${x?.client?.user?.name} ${x?.client?.user?.surname}"
                                        : "${x?.driver?.user?.name} ${x?.driver?.user?.surname}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<String>(
                                future: getAddressFromLatLng(LatLng(
                                    latitude: x?.sourcePoint?.latitude ?? 0.0,
                                    longitude:
                                        x?.sourcePoint?.longitude ?? 0.0)),
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
                                      textAlign: TextAlign.left,
                                    );
                                  }
                                },
                              ),
                              FutureBuilder<String>(
                                future: getAddressFromLatLng(LatLng(
                                    latitude:
                                        x?.destinationPoint?.latitude ?? 0.0,
                                    longitude:
                                        x?.destinationPoint?.longitude ?? 0.0)),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text("End point: Loading...");
                                  } else if (snapshot.hasError) {
                                    return Text("End point: Error");
                                  } else {
                                    return Text(
                                      "End point: ${snapshot.data?.toString()}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    );
                                  }
                                },
                              ),
                              Text(
                                "Date and time start: ${x?.startDate.toString()}" ??
                                    "",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Date and time finish: ${x?.endDate.toString()}" ??
                                    "",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Text(
                          "${x?.fullPrice} KM" ?? "",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )),
          )
          .cast<Widget>()
          .toList();
      return listRoutes;
    } else if (isRoute == false && widget?.role == "client") {
      if (rents?.result?.length == 0) {
        return [Text("Sorry there is no rents in archive")];
      }
      List<Widget> listRents = rents!.result
          .map(
            (x) => GestureDetector(
                onTap: () {},
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(color: Colors.black, strokeAlign: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          x?.vehicle?.image != null
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  child: StringHelpers.imageFromBase64String(
                                      x?.vehicle?.image!),
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.asset(
                                    "assets/images/no_image_placeholder.png",
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Renting date: ${x?.rentingDate.toString()}" ??
                                    "",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Ending date: ${x?.endingDate.toString()}" ??
                                    "",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Duration : ${x?.numberOfDays} days" ?? "",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "Vehicle name: ${x?.vehicle?.name}" ?? "",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Text(
                          "${x?.fullPrice} KM" ?? "",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )),
          )
          .cast<Widget>()
          .toList();
      return listRents;
    }
    return List.empty();
  }

  Widget _buildFooter() {
    return Padding(
        padding: EdgeInsets.only(left: 30.0),
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(minimumSize: Size(75, 50)),
                child: Text("Go back")),
            SizedBox(
              width: 30,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isRoute = true;
                });
              },
              child: Text(
                "Routes",
                style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontSize: 28,
                    fontWeight: isRoute ? FontWeight.bold : FontWeight.normal),
              ),
            ),
            SizedBox(
              width: 30,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isRoute = false;
                });
              },
              child: Text(
                "Rents",
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                  fontWeight: isRoute ? FontWeight.normal : FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(
              width: 30,
            ),
          ],
        ));
  }

  Widget _buildBackBtn() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
      },
      child: Text("Go back"),
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(76, 255, 255, 255),
          foregroundColor: Colors.black,
          minimumSize: Size(300, 50)),
    );
  }
}
