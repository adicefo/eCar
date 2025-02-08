import 'dart:convert';

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
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:ecar_mobile/models/Route/route.dart' as Model;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static const _initialPosition =
      CameraPosition(target: LatLng(44.0571, 17.4501), zoom: 12);
  LatLng? sourcePoint;
  LatLng? destinationPoint;

  late GoogleMapController _controller;

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
                        _controller = controller;
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
                "Source point:",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  _sourceAddress == null ? "Unknown" : _sourceAddress!,
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
                "Destination point:",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  _destinationAddress == null
                      ? "Unknown"
                      : _destinationAddress!,
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
      _sourceAddress = await _getAddressFromLatLng(pos);
    } else if (destinationPoint == null) {
      destinationPoint = pos;
      _destinationAddress = await _getAddressFromLatLng(pos);
    } else {
      sourcePoint = pos;
      _sourceAddress = await _getAddressFromLatLng(pos);

      destinationPoint = null;
      _destinationAddress = null;
    }
    setState(() {});
  }

//fromLatLng displays address
  Future<String> _getAddressFromLatLng(LatLng pos) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      Placemark place = placemarks[0];

      return "${place.street}, ${place.locality}";
    } catch (e) {
      print("Error getting address: $e");
      return "Unknown location";
    }
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
      route = await routeProvider.insert(request);
      await Future.delayed(const Duration(seconds: 1));
      var requestReq = {"routeId": route?.id, "driverId": route?.driverID};
      requestProvider.insert(requestReq);
      ScaffoldHelpers.showScaffold(context, "Request has been sent");
    }
  }

//start of logic for Stripe payment
  Future<void> makePayment(Model.Route? route) async {
    try {
      String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
      String customerId = await createStripeCustomer();
      paymentIntentData = await createPaymentIntent(
          route!.fullPrice.toString(), 'USD', c?.user?.email, customerId);
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

  Future<String> createStripeCustomer() async {
    try {
      String stripeSecretKey = await dotenv.env['STRIPE_SECRET_KEY'] ?? '';
      if (stripeSecretKey.isEmpty) {
        print("Stripe secret key is not set in .env file");
      }
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/customers'),
        body: {
          'email': c?.user?.email,
          'name': '${c?.user?.name} ${c?.user?.surname}',
        },
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      var customerResponse = jsonDecode(response.body);
      String customerId = customerResponse['id'];
      return customerId;
    } catch (err) {
      print('err creating stripe customer: ${err.toString()}');
      throw err;
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount,
      String currency, String? customerEmail, String customerId) async {
    try {
      String stripeSecretKey = await dotenv.env['STRIPE_SECRET_KEY'] ?? '';
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'customer': customerId,
        'receipt_email': c?.user?.email,
        'description':
            'Payment for car reservation by ${c?.user?.name} ${c?.user?.surname}',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
      throw err;
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
        await ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Payment successful via Stripe servise for ${route?.driver?.user?.name} ${route?.driver?.user?.surname}"),
            backgroundColor: Colors.red,
          ),
        );
        await routeProvider.updatePaymant(route?.id);
        var filter = {
          "ClientId": c?.id,
          "StatusNot": "finished",
        };
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RouteOrderScreen(),
          ),
        );
      } else {
        print('Payment failed.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Payment is not successful for ${route?.driver?.user?.name} ${route?.driver?.user?.surname} "),
            backgroundColor: Colors.red,
          ),
        );
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

  Future<bool> confirmPaymentSheetPayment() async {
    try {
      await Stripe.instance.confirmPaymentSheetPayment();
      return true;
    } on StripeException catch (e) {
      print('Error confirming payment: $e');
      return false;
    }
  }

  String calculateAmount(String amount) {
    final double parsedAmount = double.parse(amount);
    final int multipliedAmount = (parsedAmount * 100).toInt();
    return multipliedAmount.toString();
  }
}
