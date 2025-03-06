import 'dart:convert';
import 'dart:typed_data';

import 'package:ecar_mobile/models/Client/client.dart';
import 'package:ecar_mobile/models/DriverVehicle/driverVehicle.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/client_provider.dart';
import 'package:ecar_mobile/providers/request_provider.dart';
import 'package:ecar_mobile/providers/route_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/route_order_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/getAddresLatLng_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:ecar_mobile/utils/stripe_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:ecar_mobile/models/Route/route.dart' as Model;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';

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

  String? _sourceAddress;
  String? _destinationAddress;

  static const _initialPosition = CameraPosition(
      target: LatLng(latitude: 44.0571, longitude: 17.4501), zoom: 12);
  LatLng? sourcePoint;
  LatLng? destinationPoint;

  late GoogleMapViewController _controller;

  Marker? _sourceMark;
  Marker? _destinationMark;

  Map<String, dynamic>? paymentIntentData;
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
    try {
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
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
    }
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldHelpers.showScaffold(context,
            "Location service is not enabled. Please enable it in settings.");
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldHelpers.showScaffold(context,
            "Location permission is permanently denied. Please enable it in app settings.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        sourcePoint =
            LatLng(latitude: position.latitude, longitude: position.longitude);
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(
          context, "Error retrieving location: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? getisLoadingHelper()
        : MasterScreen(
            "Order",
            widget.isOrder!
                ? SingleChildScrollView(child: _buildScreen())
                : _buildListOrders());
  }

  Widget _buildScreen() {
    return Column(
      children: [
        Container(
            height: 350,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Colors.yellowAccent),
            child: SizedBox(
                height: 350,
                width: double.infinity,
                child: Center(
                  child: GoogleMapsMapView(
                    initialCameraPosition: _initialPosition,
                    onViewCreated: (GoogleMapViewController controller) {
                      _controller = controller;
                    },
                    onMapLongClicked: addMarker,
                  ),
                ))),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Driver:",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${widget.object?.driver?.user?.name} ${widget.object?.driver?.user?.surname}",
                  style: TextStyle(
                      fontSize: 16,
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
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Source point:\n ${_sourceAddress == null ? "Unknown" : _sourceAddress!}",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Destination point:\n ${_destinationAddress == null ? "Unknown" : _destinationAddress!}",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
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
                  backgroundColor: const Color.fromARGB(76, 255, 255, 255),
                  foregroundColor: Colors.black,
                  minimumSize: Size(150, 50)),
            ),
            SizedBox(
              width: 30,
            ),
            ElevatedButton(
              onPressed: () {
                _sendRouteAndRequest();
              },
              child: Text("Send"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(76, 255, 255, 255),
                  foregroundColor: Colors.black,
                  minimumSize: Size(150, 50)),
            )
          ],
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
                buildHeader("My orders"),
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
                  Text("Price: ${x.fullPrice}KM",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Center(
                      child: Text(
                          "Number of kilometars:\n              ${x.numberOfKilometars}",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Text("Status: ${x.status}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                      onPressed: () async {
                        if (x?.paid == true) {
                          AlertHelpers.showAlert(
                              context, "Warning", "You have already paid");
                          return;
                        }
                        await makePayment(x);
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

  void addMarker(LatLng pos) async {
    if (sourcePoint == null) {
      sourcePoint = pos;
      _sourceAddress = await getAddressFromLatLng(pos);

      _sourceMark = Marker(
        markerId: "sourceMark",
        options: MarkerOptions(
          infoWindow: const InfoWindow(title: "Source point"),
          icon: ImageDescriptor.defaultImage,
          position: sourcePoint!,
        ),
      );

      _controller.addMarkers([_sourceMark!.options]);
    } else if (destinationPoint == null) {
      destinationPoint = pos;
      _destinationAddress = await getAddressFromLatLng(pos);

      _destinationMark = Marker(
        markerId: "destinationMark",
        options: MarkerOptions(
          infoWindow: const InfoWindow(title: "Destination point"),
          icon: ImageDescriptor.defaultImage,
          position: destinationPoint!,
        ),
      );

      _controller.addMarkers([_destinationMark!.options]);
    } else {
      _controller.clearMarkers();

      sourcePoint = pos;
      destinationPoint = null;
      _sourceAddress = await getAddressFromLatLng(pos);
      _destinationAddress = null;

      _sourceMark = Marker(
        markerId: "sourceMark",
        options: MarkerOptions(
          infoWindow: const InfoWindow(title: "Source point"),
          icon: ImageDescriptor.defaultImage,
          position: sourcePoint!,
        ),
      );

      _controller.addMarkers([_sourceMark!.options]);
    }

    // Refresh UI
    setState(() {});
  }

//request to my api
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
      try {
        route = await routeProvider.insert(request);
        await Future.delayed(const Duration(seconds: 1));
        var requestReq = {"routeId": route?.id, "driverId": route?.driverID};
        requestProvider.insert(requestReq);
        ScaffoldHelpers.showScaffold(context, "Request has been sent");
        await Future.delayed(const Duration(seconds: 1));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RouteOrderScreen(),
          ),
        );
      } catch (e) {
        ScaffoldHelpers.showScaffold(context, "${e.toString()}");
      }
    }
  }

//start of logic for Stripe payment
  Future<void> makePayment(Model.Route? route) async {
    try {
      String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
      String customerId = await createStripeCustomer(
          c?.user?.email, c?.user?.name, c?.user?.surname);
      paymentIntentData = await createPaymentIntent(route!.fullPrice.toString(),
          'BAM', c?.user?.email, customerId, c?.user?.name, c?.user?.surname);
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              setupIntentClientSecret: stripeSecretKey,
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              customFlow: true,
              style: ThemeMode.dark,
              merchantDisplayName: 'test',
            ),
          )
          .then((value) {});
      displayPaymentSheet(route);
    } catch (e) {
      print("Payment exception: $e");
    }
  }

  Future<void> displayPaymentSheet(Model.Route? route) async {
    try {
      final result = await Stripe.instance.presentPaymentSheet();
      if (result == null) {
        return;
      }
      final confirmed = await confirmPaymentSheetPayment();
      if (confirmed) {
        ScaffoldHelpers.showScaffold(context,
            "Payment successful via Stripe servise for ${route?.driver?.user?.name} ${route?.driver?.user?.surname}");
        await routeProvider.updatePaymant(route?.id);
        var filter = {
          "ClientId": c?.id,
          "StatusNot": "finished",
        };
        routeProvider.get(filter: filter);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RouteOrderScreen(),
          ),
        );
      } else {
        print('Payment failed.');
        ScaffoldHelpers.showScaffold(context,
            "Payment is unsuccessfull for ${route?.driver?.user?.name} ${route?.driver?.user?.surname}");
      }
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Cancelled "),
        ),
      );
    } catch (e) {
      print('$e');
    }
  }
}
