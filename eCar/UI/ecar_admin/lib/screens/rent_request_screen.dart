import 'package:ecar_admin/models/Rent/rent.dart';
import 'package:ecar_admin/providers/rent_provider.dart';
import 'package:ecar_admin/screens/rent_screen.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/string_helpers.dart' as help;
import 'package:ecar_admin/utils/alert_helpers.dart';

class RentRequestScreen extends StatefulWidget {
  Rent? rent;
  RentRequestScreen({super.key, this.rent});

  @override
  State<RentRequestScreen> createState() => _RentRequestScreenState();
}

class _RentRequestScreenState extends State<RentRequestScreen> {
  late TextEditingController _clientNameController;
  late TextEditingController _rentingDateController;
  late TextEditingController _endingDateController;
  late TextEditingController _fullPriceController;
  late TextEditingController _numberOfDaysController;
  late TextEditingController _vehicleNameController;

  late RentProvider provider;

  bool isLoading = true;
  bool vehicleAvailability = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = context.read<RentProvider>();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _fetchAvailabilitiy();
    _initControllers();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchAvailabilitiy() async {
    var request = {
      "vehicleId": widget.rent?.vehicleId,
      "rentingDate": (widget.rent?.rentingDate as DateTime).toIso8601String(),
      "endingDate": (widget.rent?.endingDate as DateTime).toIso8601String()
    };
    vehicleAvailability =
        await provider.checkAvailability(widget.rent?.id, request);
  }

  void _initControllers() {
    _clientNameController = TextEditingController(
      text:
          "${widget.rent?.client?.user?.name ?? ''} ${widget.rent?.client?.user?.surname ?? ''}",
    );
    _rentingDateController = TextEditingController(
      text:
          "${widget.rent?.rentingDate?.day}.${widget.rent?.rentingDate?.month}.${widget.rent?.rentingDate?.year}",
    );
    _endingDateController = TextEditingController(
      text:
          "${widget.rent?.endingDate?.day}.${widget.rent?.endingDate?.month}.${widget.rent?.endingDate?.year}",
    );
    _numberOfDaysController =
        TextEditingController(text: "Days total: ${widget.rent?.numberOfDays}");
    _fullPriceController =
        TextEditingController(text: "Full price: ${widget.rent?.fullPrice}");
    _vehicleNameController =
        TextEditingController(text: "${widget.rent?.vehicle?.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Rent Acceptance for ${widget.rent?.client?.user?.name} ${widget.rent?.client?.user?.surname}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => RentScreen()));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [isLoading ? Container() : _buildView(), _save()],
        ),
      ),
    );
  }

  Widget _buildView() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Client name", _clientNameController),
                SizedBox(height: 10),
                _buildTextField("Renting date", _rentingDateController),
                SizedBox(height: 10),
                _buildTextField("Ending date", _endingDateController),
                SizedBox(height: 10),
                _buildTextField("Number of days", _numberOfDaysController),
                SizedBox(height: 10),
                _buildTextField("Full price", _fullPriceController),
                SizedBox(height: 10),
                _buildTextField("Vehicle name", _vehicleNameController),
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (widget.rent?.vehicle?.image != null)
                    ? Container(
                        width: 300,
                        height: 300,
                        child: help.StringHelpers.imageFromBase64String(
                            widget.rent?.vehicle?.image),
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
                SizedBox(height: 20),
                Tooltip(
                  message: vehicleAvailability
                      ? "Car is available"
                      : "Car is not available",
                  child: Icon(
                    Icons.circle,
                    size: 60,
                    color: vehicleAvailability ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.black,
          labelStyle:
              TextStyle(color: Colors.white, fontStyle: FontStyle.normal),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellowAccent),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellowAccent),
          ),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _save() {
    bool? confirmEdit;
    return Padding(
      padding: const EdgeInsets.only(top: 116.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () async {
              confirmEdit = await AlertHelpers.editConfirmation(context);
              if (confirmEdit == true) {
                try {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        'Request has been denied',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )));
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RentScreen()));
                  provider.delete(widget.rent?.id);
                } catch (e) {
                  ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(300, 50),
            ),
            child: const Text("Reject"),
          ),
          SizedBox(
            width: 120,
          ),
          ElevatedButton(
            onPressed: () async {
              confirmEdit = await AlertHelpers.editConfirmation(context);
              if (confirmEdit == true) {
                try {
                  provider.updateActive(widget.rent?.id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.lightGreen,
                      content: Text(
                        'Request has been accepted',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )));
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RentScreen()));
                } catch (e) {
                  ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.black,
              minimumSize: Size(300, 50),
            ),
            child: const Text("Accept"),
          ),
          SizedBox(
            width: 50,
          ),
        ],
      ),
    );
  }
}
