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
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:provider/provider.dart';

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
      firstDate: DateTime.now(),
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
        Align(
          alignment: Alignment.center,
          child: buildHeader("Choose your \n rent period"),
        ),
        _buildButtonPick(),
        SizedBox(
          height: 20,
        ),
        _buildContent(),
        SizedBox(
          height: 20,
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
    bool? confirmEdit = await AlertHelpers.rentRequestConfirmation(context);
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
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            "Tap to select rental dates",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200, width: 2),
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 28,
                  color: Colors.amber.shade700,
                ),
                SizedBox(width: 12),
                Text(
                  "${_startDate.toString().substring(0, 10)} - ${_endDate.toString().substring(0, 10)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.amber.shade700,
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _selectDateRange,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Change dates",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rental Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Divider(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.timelapse, color: Colors.blue.shade700),
              ),
              title: Text("Duration", style: TextStyle(color: Colors.grey.shade700)),
              subtitle: Text(
                "${_duration} days",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.directions_car, color: Colors.green.shade700),
              ),
              title: Text("Vehicle", style: TextStyle(color: Colors.grey.shade700)),
              subtitle: Text(
                "${widget?.object?.name}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.local_gas_station, color: Colors.orange.shade700),
              ),
              title: Text("Consumption", style: TextStyle(color: Colors.grey.shade700)),
              subtitle: Text(
                "${widget?.object?.averageConsumption} l/100km",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.attach_money, color: Colors.purple.shade700),
              ),
              title: Text("Total Price", style: TextStyle(color: Colors.grey.shade700)),
              subtitle: Text(
                "${_fullPrice?.toStringAsFixed(2) ?? '0.00'} KM",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            
            SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RentScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text("Go back"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _sendRentRequest();
                  },
                  icon: Icon(Icons.send),
                  label: Text("Send request"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade300,
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommenderContent() {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.orange.shade50,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lightbulb, color: Colors.orange.shade700),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Others are also looking at these vehicles",
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  _recommenderObj = await rentProvider.recommend(widget?.object?.id);
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
              icon: Icon(Icons.recommend),
              label: Text(
                "View Recommendations",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListRents() {
    return Column(
      children: [
        Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RentScreen()),
                  );
                },
                icon: Icon(Icons.arrow_back, size: 30, color: Colors.black87),
                tooltip: "Back",
              ),),
           Padding(
            padding: EdgeInsets.only(left: 70),
            child:  buildHeader("My rents"),
           )
          ], 
        ),
        SizedBox(height: 16),
        Expanded(
          child: data?.result == null || data!.result.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.car_rental_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No rentals available",
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
                itemCount: data!.result.length,
                itemBuilder: (context, index) => _buildRentItem(data!.result[index]),
              ),
        ),
        
      ],
    );
  }

  Widget _buildRentItem(Rent rent) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: rent.status == "wait" 
                ? Colors.orange.shade100 
                : rent.status == "active" 
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
                  rent.status == "wait" 
                    ? Icons.hourglass_top 
                    : rent.status == "active" 
                      ? Icons.car_rental 
                      : Icons.check_circle,
                  color: rent.status == "wait" 
                    ? Colors.orange.shade800 
                    : rent.status == "active" 
                      ? Colors.blue.shade800 
                      : Colors.green.shade800,
                  size: 16,
                ),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    rent.status == "wait" 
                      ? "WAITING" 
                      : rent.status == "active" 
                        ? "ACTIVE" 
                        : "COMPLETED",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: rent.status == "wait" 
                        ? Colors.orange.shade800 
                        : rent.status == "active" 
                          ? Colors.blue.shade800 
                          : Colors.green.shade800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(Icons.date_range, size: 16, color: Colors.black87),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rental Period",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "${rent.rentingDate?.toString().substring(0, 10) ?? 'N/A'} - ${rent.endingDate?.toString().substring(0, 10) ?? 'N/A'}",
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
                
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(Icons.attach_money, size: 16, color: Colors.black87),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Price",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "${rent.fullPrice?.toStringAsFixed(2) ?? '0.00'} KM",
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
          
          InkWell(
            onTap: () async {
              if (rent.paid == true) {
                AlertHelpers.showAlert(
                    context, "Already Paid", "You have already paid for this rental");
                return;
              }
              if (rent.status == "wait") {
                AlertHelpers.showAlert(context, "Payment Not Available",
                    "Only active rentals can be paid.");
                return;
              }
              await makePayment(rent);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: rent.paid == true 
                  ? Colors.grey.shade200 
                  : (rent.status == "wait" 
                    ? Colors.grey.shade300 
                    : Colors.black),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    rent.paid == true 
                      ? Icons.check_circle 
                      : (rent.status == "wait" 
                        ? Icons.hourglass_disabled 
                        : Icons.payment),
                    color: rent.paid == true 
                      ? Colors.green 
                      : (rent.status == "wait" 
                        ? Colors.grey.shade600 
                        : Colors.yellow),
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    rent.paid == true 
                      ? "PAID" 
                      : (rent.status == "wait" 
                        ? "PENDING" 
                        : "PAY NOW"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: rent.paid == true 
                        ? Colors.green 
                        : (rent.status == "wait" 
                          ? Colors.grey.shade600 
                          : Colors.white),
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

  //start of logic for Stripe payment
  Future<void> makePayment(Rent? rent) async {
    try {
      String stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
      String customerId = await createStripeCustomer(
          c?.user?.email, c?.user?.name, c?.user?.surname);
      paymentIntentData = await createPaymentIntent(rent!.fullPrice.toString(),
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
      displayPaymentSheet(rent);
    } catch (e) {
      print("Payment exception: $e");
    }
  }

  Future<void> displayPaymentSheet(Rent? rent) async {
    try {
      final result = await stripe.Stripe.instance.presentPaymentSheet();
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
