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
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
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
                    fontSize: 18,
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
                    fontSize: 18,
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
    return Column(
      children: [
        buildHeader("My orders"),
        SizedBox(height: 16),
        Expanded(
          child: routes?.result == null || routes!.result.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.route_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No routes available",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: routes!.result.length,
                itemBuilder: (context, index) => _buildRouteItem(routes!.result[index]),
              ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
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
                backgroundColor: const Color.fromARGB(76, 255, 255, 255),
                foregroundColor: Colors.black,
                minimumSize: Size(200, 50)),
          ),
        )
      ],
    );
  }

  Widget _buildRouteItem(Model.Route route) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: route.status == "wait" 
                ? Colors.orange.shade100 
                : route.status == "active" 
                  ? Colors.blue.shade100 
                  : Colors.green.shade100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  route.status == "wait" 
                    ? Icons.hourglass_top 
                    : route.status == "active" 
                      ? Icons.directions_car 
                      : Icons.check_circle,
                  color: route.status == "wait" 
                    ? Colors.orange.shade800 
                    : route.status == "active" 
                      ? Colors.blue.shade800 
                      : Colors.green.shade800,
                  size: 16,
                ),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    "Status: ${route.status?.toUpperCase() ?? 'UNKNOWN'}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: route.status == "wait" 
                        ? Colors.orange.shade800 
                        : route.status == "active" 
                          ? Colors.blue.shade800 
                          : Colors.green.shade800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Driver info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(Icons.person, size: 16, color: Colors.black87),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Driver",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "${route.driver?.user?.name ?? ''} ${route.driver?.user?.surname ?? ''}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                Divider(height: 16),
                
                // Route details
                Row(
                  children: [
                    // Price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "${route.fullPrice?.toStringAsFixed(2) ?? '0.00'} KM",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Distance
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Distance",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "${route.numberOfKilometars?.toStringAsFixed(1) ?? '0.0'} km",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Payment button
          InkWell(
            onTap: () async {
              if (route.paid == true) {
                AlertHelpers.showAlert(
                    context, "Already Paid", "You have already paid for this route");
                return;
              }
              await makePayment(route);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: route.paid == true ? Colors.grey.shade200 : Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    route.paid == true ? Icons.check_circle : Icons.payment,
                    color: route.paid == true ? Colors.green : Colors.yellow,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    route.paid == true ? "PAID" : "PAY NOW",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: route.paid == true ? Colors.green : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
      await stripe.Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: stripe.SetupPaymentSheetParameters(
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
      final result = await stripe.Stripe.instance.presentPaymentSheet();
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
    } on stripe.StripeException catch (e) {
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
