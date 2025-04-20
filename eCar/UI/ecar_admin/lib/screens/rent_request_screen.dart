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
    try {
      var request = {
        "vehicleId": widget.rent?.vehicleId,
        "rentingDate": (widget.rent?.rentingDate as DateTime).toIso8601String(),
        "endingDate": (widget.rent?.endingDate as DateTime).toIso8601String()
      };
      vehicleAvailability =
          await provider.checkAvailability(widget.rent?.id, request);
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
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
        TextEditingController(text: "${widget.rent?.numberOfDays}");
    _fullPriceController =
        TextEditingController(text: "${widget.rent?.fullPrice} KM");
    _vehicleNameController =
        TextEditingController(text: "${widget.rent?.vehicle?.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Rent Request: ${widget.rent?.client?.user?.name} ${widget.rent?.client?.user?.surname}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => RentScreen()));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.yellowAccent))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvailabilityBanner(),
                    SizedBox(height: 20),
                    _buildContent(),
                    SizedBox(height: 30),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAvailabilityBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: vehicleAvailability
            ? Colors.green.withOpacity(0.8)
            : Colors.red.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            vehicleAvailability ? Icons.check_circle : Icons.cancel,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(width: 12),
          Text(
            vehicleAvailability
                ? "Vehicle is available for the requested dates"
                : "Vehicle is NOT available for the requested dates",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Card(
      color: Colors.grey.shade900,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.yellowAccent.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rental Details",
              style: TextStyle(
                color: Colors.yellowAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Details
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                          "Client", _clientNameController.text, Icons.person),
                      _buildDetailItem("Vehicle", _vehicleNameController.text,
                          Icons.directions_car),
                      _buildDetailItem("Start Date",
                          _rentingDateController.text, Icons.calendar_today),
                      _buildDetailItem("End Date", _endingDateController.text,
                          Icons.event_available),
                      _buildDetailItem(
                          "Duration",
                          "${_numberOfDaysController.text} days",
                          Icons.timelapse),
                      _buildDetailItem("Total Price", _fullPriceController.text,
                          Icons.attach_money),
                    ],
                  ),
                ),
                SizedBox(width: 40),
                // Right side - Vehicle Image
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Vehicle Image",
                        style: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.yellowAccent.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (widget.rent?.vehicle?.image != null)
                              ? help.StringHelpers.imageFromBase64String(
                                  widget.rent?.vehicle?.image)
                              : Image.asset(
                                  "assets/images/no_image_placeholder.png",
                                  height: 160,
                                  width: 160,
                                  fit: BoxFit.cover,
                                ),
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
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.yellowAccent.withOpacity(0.3)),
            ),
            child: Icon(icon, color: Colors.yellowAccent, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Back Button
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => RentScreen(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
          label: Text("Go Back"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.yellowAccent,
            side: BorderSide(color: Colors.yellowAccent),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
        SizedBox(width: 30),
        // Reject Button
        ElevatedButton.icon(
          onPressed: () async {
            bool? confirmEdit = await AlertHelpers.editConfirmation(context);
            if (confirmEdit == true) {
              try {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.redAccent,
                    content: Text(
                      'Request has been denied',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )));
                provider.delete(widget.rent?.id);
                await Future.delayed(const Duration(seconds: 2));
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => RentScreen()));
              } catch (e) {
                ScaffoldHelpers.showScaffold(context, "${e.toString()}");
              }
            }
          },
          icon: Icon(Icons.cancel),
          label: Text("Reject Request"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(width: 30),
        // Accept Button
        ElevatedButton.icon(
          onPressed: vehicleAvailability
              ? () async {
                  bool? confirmEdit =
                      await AlertHelpers.editConfirmation(context);
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
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => RentScreen()));
                    } catch (e) {
                      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                    }
                  }
                }
              : null, // Disable button if vehicle isn't available
          icon: Icon(Icons.check_circle),
          label: Text("Accept Request"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            disabledBackgroundColor: Colors.grey.shade700,
            disabledForegroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
