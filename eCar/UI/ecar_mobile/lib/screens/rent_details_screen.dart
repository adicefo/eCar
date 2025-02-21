import 'package:ecar_mobile/models/Client/client.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/Vehicle/vehicle.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/client_provider.dart';
import 'package:ecar_mobile/providers/rent_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helper.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class RentDetailsScreen extends StatefulWidget {
  Vehicle? object;
  RentDetailsScreen({super.key, required this.object});

  @override
  State<RentDetailsScreen> createState() => _RentDetailsScreenState();
}

class _RentDetailsScreenState extends State<RentDetailsScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  int _duration = 1;
  double? _price;
  double? _fullPrice;
  bool _showPicker = false;
  User? user = null;

  SearchResult<Client>? client;
  Client? c;

  late UserProvider userProvider;
  late ClientProvider clientProvider;
  late RentProvider rentProvider;

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
    user = await userProvider.getUserFromToken();

    var filterClient = {"NameGTE": user?.name, "SurnameGTE": user?.surname};
    client = await clientProvider.get(filter: filterClient);

    c = client?.result.first;
    setState(() {
      isLoading = false;
    });
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
        : MasterScreen("Rent", _buildScreen());
  }

  Widget _buildScreen() {
    return Column(
      children: [
        _buildHeader(),
        _buildButtonPick(),
        SizedBox(
          height: 70,
        ),
        _buildContent(),
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
      await rentProvider.insert(request);
      await Future.delayed(const Duration(seconds: 1));
      ScaffoldHelpers.showScaffold(context, "Request has been sent");
    }
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                "Choose your rent\n         period",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget _buildButtonPick() {
    return Padding(
      padding: EdgeInsets.only(top: 60),
      child: ElevatedButton(
        onPressed: _selectDateRange,
        child: Text("Pick Date Range"),
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 218, 212, 196),
            foregroundColor: Colors.black,
            minimumSize: Size(70, 70)),
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${_startDate.toString().substring(0, 10)}",
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
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "End date:",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${_endDate.toString().substring(0, 10)}",
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
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Car name: ",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${widget?.object?.name}",
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
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Consumption: ",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${widget?.object?.averageConsumption} l/100km",
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
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                "Price: ",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  "${_fullPrice.toString()} KM",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                )),
          ],
        ),
        SizedBox(
          height: 35,
        ),
        ElevatedButton(
          onPressed: () {
            _sendRentRequest();
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
}
