import 'package:ecar_mobile/models/Client/client.dart';
import 'package:ecar_mobile/models/DriverVehicle/driverVehicle.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/client_provider.dart';
import 'package:ecar_mobile/providers/request_provider.dart';
import 'package:ecar_mobile/providers/route_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/map_screen.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/route_order_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:ecar_mobile/models/Route/route.dart' as Model;
import 'package:provider/provider.dart';

class RouteOrderDetailsScreen extends StatefulWidget {
  DriverVehicle? object;
  bool? isOrder;
  RouteOrderDetailsScreen(this.isOrder, {super.key, this.object});

  @override
  State<RouteOrderDetailsScreen> createState() =>
      _RouteOrderDetailsScreenState();
}

//TODO: Finish logic for Geolocator
class _RouteOrderDetailsScreenState extends State<RouteOrderDetailsScreen> {
  Model.Route? route = null;
  User? user = null;
  Client? c = null;

  SearchResult<Client>? client;
  SearchResult<Model.Route>? routes;
  late RouteProvider routeProvider;
  late RequestProvider requestProvider;
  late UserProvider userProvider;
  late ClientProvider clientProvider;

  static const _initialPosition =
      CameraPosition(target: LatLng(44.0571, 17.4501), zoom: 12);
  LatLng? sourcePoint;
  LatLng? destinationPoint;

  final Completer<GoogleMapController> _controller = Completer();

  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    routeProvider = context.read<RouteProvider>();
    requestProvider = context.read<RequestProvider>();
    userProvider = context.read<UserProvider>();
    clientProvider = context.read<ClientProvider>();
    super.initState();
    _initForm();
    _getUserLocation();
  }

  Future<void> _initForm() async {
    user = await userProvider.getUserFromToken();
    var filter = {"NameGTE": user?.name, "SurnameGTE": user?.surname};
    client = await clientProvider.get(filter: filter);
    //taking only one from SearchResult
    c = client?.result.first;

    if (widget?.isOrder == false) {
      var filter = {
        "ClientId": c?.id,
        "StatusNot": "finished",
      };
      routes = await routeProvider.get(filter: filter);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location service not enabled");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      sourcePoint = LatLng(position.latitude, position.longitude);
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
              child: Text("Go back"),
            ),
          )
        : MasterScreen(
            "Order", widget.isOrder! ? _buildScreen() : _buildListOrders());
  }

  Widget _buildScreen() {
    return Column(
      children: [
        Container(
            height: 400,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.yellowAccent),
            child: SizedBox(
                height: 400,
                width: double.infinity,
                child: Center(
                  child: GoogleMap(
                      initialCameraPosition: _initialPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: {
                        if (sourcePoint != null)
                          Marker(
                              markerId: const MarkerId("sourceMark"),
                              infoWindow:
                                  const InfoWindow(title: "Source point"),
                              icon: BitmapDescriptor.defaultMarker,
                              position: sourcePoint!),
                        if (destinationPoint != null)
                          Marker(
                              markerId: const MarkerId("destinationMark"),
                              infoWindow:
                                  const InfoWindow(title: "Destination point"),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueOrange),
                              position: destinationPoint!),
                      },
                      onLongPress: addMarker,
                      mapType: MapType.normal),
                ))),
        SizedBox(
          height: 50,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Driver:",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "${widget.object?.driver?.user?.name} ${widget.object?.driver?.user?.surname}",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Source point:",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  sourcePoint == null
                      ? "Not set..."
                      : sourcePoint!.latitude.toStringAsFixed(3),
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Destination point:",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  destinationPoint == null
                      ? "Not set..."
                      : destinationPoint!.latitude.toStringAsFixed(3),
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                )),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            _sendRouteAndRequest();
          },
          child: Text("Send"),
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(76, 255, 255, 255),
              foregroundColor: Colors.black,
              minimumSize: Size(200, 50)),
        )
      ],
    );
  }

  Widget _buildListOrders() {
    return SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 350,
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1),
                    scrollDirection: Axis.horizontal,
                    children: _buildOrderGrid(),
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteOrderScreen(),
                        ),
                      );
                    },
                    child: Text("Go back"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(76, 255, 255, 255),
                        foregroundColor: Colors.black,
                        minimumSize: Size(200, 50)),
                  ),
                )
              ],
            )));
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                "My orders",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  List<Widget> _buildOrderGrid() {
    if (routes?.result?.length == 0) {
      return [SizedBox.shrink()];
    }
    List<Widget> list = routes!.result
        .map((x) => Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(color: Colors.black, strokeAlign: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    "Driver: ${x?.driver?.user?.name} ${x?.driver?.user?.surname}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Price: ${x.fullPrice}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Center(
                      child: Text(
                          "Number of kilometars:\n              ${x.numberOfKilometars}",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Text("Status: ${x.status}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () {
                        AlertHelpers.showAlert(
                            context, "Info", "Still not implemented");
                      },
                      icon: Icon(
                        Icons.add_circle_sharp,
                        color: Colors.deepOrangeAccent,
                      ))
                ],
              ),
            ))
        .cast<Widget>()
        .toList();
    return list;
  }

  void addMarker(LatLng pos) {
    setState(() {
      if (sourcePoint == null) {
        sourcePoint = pos;
      } else if (destinationPoint == null) {
        destinationPoint = pos;
      } else {
        sourcePoint = pos;
        destinationPoint = null;
      }
    });
  }

  Future<void> _sendRouteAndRequest() async {
    if (sourcePoint == null || destinationPoint == null) {
      AlertHelpers.showAlert(
          context, "Error", "You must set both source and destination point");
      return;
    }
    bool? confirmEdit = await AlertHelpers.editConfirmation(context,
        text: "Do you want to send drive request?");
    if (confirmEdit == true) {
      var request = {
        "sourcePoint": {
          "latitude": sourcePoint?.latitude,
          "longitude": sourcePoint?.longitude,
          "srid": 4326,
        },
        "destinationPoint": {
          "latitude": destinationPoint?.latitude,
          "longitude": destinationPoint?.longitude,
          "srid": 4326,
        },
        "clientId": c?.id,
        "driverID": widget?.object?.driverId,
      };
      route = await routeProvider.insert(request);
      await Future.delayed(const Duration(seconds: 1));
      var requestReq = {"routeId": route?.id, "driverId": route?.driverID};
      requestProvider.insert(requestReq);
      ScaffoldHelpers.showScaffold(context, "Request has been sent");
    }
  }
}
