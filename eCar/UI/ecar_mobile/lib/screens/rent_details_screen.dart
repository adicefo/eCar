import 'dart:convert';

import 'package:ecar_mobile/models/Client/client.dart';
import 'package:ecar_mobile/models/Rent/rent.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/Vehicle/vehicle.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/client_provider.dart';
import 'package:ecar_mobile/providers/rent_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/recommendation_screen.dart';
import 'package:ecar_mobile/screens/rent_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:ecar_mobile/utils/stripe_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RentDetailsScreen extends StatefulWidget {
  bool? isOrder;
  Vehicle? object;
  RentDetailsScreen(this.isOrder, {super.key, this.object});

  @override
  State<RentDetailsScreen> createState() => _RentDetailsScreenState();
}

class _RentDetailsScreenState extends State<RentDetailsScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  int _duration = 1;
  double? _price;
  double? _fullPrice;

  User? user = null;

  SearchResult<Rent>? data;

  SearchResult<Client>? client;
  Client? c;

  List<Rent>? _recommenderObj = null;

  late UserProvider userProvider;
  late ClientProvider clientProvider;
  late RentProvider rentProvider;

  Map<String, dynamic>? paymentIntentData;

  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    userProvider = context.read<UserProvider>();
    clientProvider = context.read<ClientProvider>();
    rentProvider = context.read<RentProvider>();

    _price = widget?.object?.price;
    _fullPrice = _price;
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    try {
      user = await userProvider.getUserFromToken();

      var filterClient = {"NameGTE": user?.name, "SurnameGTE": user?.surname};
      client = await clientProvider.get(filter: filterClient);

      c = client?.result.first;

      if (widget.isOrder == false) {
        var filter = {"ClientId": c?.id, "StatusNot": "finished"};
        data = await rentProvider.get(filter: filter);
      }
      setState(() {
        isLoading = false;
        if (widget?.isOrder == true) {
          _duration = _endDate.day - _startDate.day;
          _fullPrice = _duration * _price!;
        }
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
    }
  }

  void _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
      saveText: "Save",
      errorInvalidRangeText: "Choose a valid range",
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _duration = picked.duration.inDays;
        _fullPrice = _price! * _duration;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? getisLoadingHelper()
        : MasterScreen(
            "Rent",
            widget.isOrder!
                ? SingleChildScrollView(child: _buildScreen())
                : _buildListRents());
  }

  Widget _buildScreen() {
    return Column(
      children: [
        buildHeader("Choose your rent\n         period"),
        _buildButtonPick(),
        SizedBox(
          height: 30,
        ),
        _buildContent(),
        SizedBox(
          height: 10,
        ),
        _buildRecommenderContent(),
      ],
    );
  }

  Future<void> _sendRentRequest() async {
    if (_startDate == null || _endDate == null) {
      AlertHelpers.showAlert(
          context, "Error", "You must set both start and end date");
      return;
    }
    bool? confirmEdit = await AlertHelpers.editConfirmation(context,
        text: "Do you want to send rent request?");
    if (confirmEdit == true) {
      var request = {
        "rentingDate": _startDate.toIso8601String(),
        "endingDate": _endDate.toIso8601String(),
        "vehicleId": widget?.object?.id,
        "clientId": c?.id
      };
      try {
        await rentProvider.insert(request);
        await Future.delayed(const Duration(seconds: 1));
        ScaffoldHelpers.showScaffold(context, "Request has been sent");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RentDetailsScreen(false),
          ),
        );
      } catch (e) {
        ScaffoldHelpers.showScaffold(context, "${e.toString()}");
      }
    }
  }

  Widget _buildButtonPick() {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: IconButton(
        onPressed: _selectDateRange,
        icon: Icon(Icons.date_range),
        iconSize: 50,
        color: Colors.amber,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Start date:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${_startDate.toString().substring(0, 10)}",
                  style: TextStyle(
                      fontSize: 20,
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
                "End date:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${_endDate.toString().substring(0, 10)}",
                  style: TextStyle(
                      fontSize: 20,
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
                "Duration:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${_duration} days",
                  style: TextStyle(
                      fontSize: 20,
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
                "Car name: ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${widget?.object?.name}",
                  style: TextStyle(
                      fontSize: 20,
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
                "Consumption: ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${widget?.object?.averageConsumption} l/100km",
                  style: TextStyle(
                      fontSize: 20,
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
                "Price: ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${_fullPrice.toString()} KM",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                )),
          ],
        ),
        SizedBox(
          height: 35,
        ),
        SizedBox(
          width: 350,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RentScreen(),
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
                width: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  _sendRentRequest();
                },
                child: Text("Send"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(76, 255, 255, 255),
                    foregroundColor: Colors.black,
                    minimumSize: Size(150, 50)),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildRecommenderContent() {
    return Column(
      children: [
        Center(
          child: Text(
            "Others are also looking...See recomendation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              try {
                _recommenderObj =
                    await rentProvider.recommend(widget?.object?.id);
                print("Lenght of list: ${_recommenderObj!.length}");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecommendationScreen(
                      recommendationList: _recommenderObj,
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldHelpers.showScaffold(context, "${e.toString()}");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              minimumSize: Size(50, 50),
            ),
            child: Text(
              "Recommendation",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }

  Widget _buildListRents() {
    return SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                buildHeader("My rents"),
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
                          builder: (context) => RentScreen(),
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
    if (data?.result?.length == 0) {
      return [SizedBox.shrink()];
    }
    List<Widget> list = data!.result
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
                    "Renting date: ${x?.rentingDate.toString().substring(0, 10)}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "Ending date: ${x?.endingDate.toString().substring(0, 10)}",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Full price: ${x?.fullPrice.toString()} KM",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Center(
                      child: Text(
                          "Status: ${x.status == "wait" ? "Waiting for response" : "Rent is active"}",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  IconButton(
                      onPressed: () async {
                        if (x?.paid == true) {
                          AlertHelpers.showAlert(
                              context, "Warning", "You have already paid");
                          return;
                        }
                        if (x.status == "wait") {
                          AlertHelpers.showAlert(context, "Warning",
                              "Only active rents can be paid.");
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

  //start of logic for Stripe payment
  Future<void> makePayment(Rent? rent) async {
    try {
      String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
      String customerId = await createStripeCustomer(
          c?.user?.email, c?.user?.name, c?.user?.surname);
      paymentIntentData = await createPaymentIntent(rent!.fullPrice.toString(),
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
      displayPaymentSheet(rent);
    } catch (e) {
      print("Payment exception: $e");
    }
  }

  Future<void> displayPaymentSheet(Rent? rent) async {
    try {
      final result = await Stripe.instance.presentPaymentSheet();
      if (result == null) {
        return;
      }
      final confirmed = await confirmPaymentSheetPayment();
      if (confirmed) {
        ScaffoldHelpers.showScaffold(
            context, "Payment successful via Stripe servise.");
        await rentProvider.updatePaymant(rent?.id);
        var filter = {
          "ClientId": c?.id,
          "StatusNot": "finished",
        };
        rentProvider.get(filter: filter);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RentScreen(),
          ),
        );
      } else {
        print('Payment failed.');
        ScaffoldHelpers.showScaffold(context, "Payment is unsuccessful.");
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
