import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/driverVehicle_provider.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/vehicle_provider.dart';
import 'package:ecar_admin/screens/driverVehicle_screen.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverVehicleDetailsScreen extends StatefulWidget {
  const DriverVehicleDetailsScreen({super.key});

  @override
  State<DriverVehicleDetailsScreen> createState() =>
      _DriverVehicleDetailsScreenState();
}

class _DriverVehicleDetailsScreenState
    extends State<DriverVehicleDetailsScreen> {
  SearchResult<Driver>? drivers;
  SearchResult<Vehicle>? vehicles;

  Driver? _selectedDriver = null;
  Vehicle? _selectedVehicle = null;

  late VehicleProvider vehicleProvider;
  late DriverProvider driverProvider;
  late DriverVehicleProvider driverVehicleProvider;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    driverProvider = context.read<DriverProvider>();
    vehicleProvider = context.read<VehicleProvider>();
    driverVehicleProvider = context.read<DriverVehicleProvider>();
    _initForm();
  }

  Future<void> _initForm() async {
    try {
      drivers = await driverProvider.get();

      vehicles = await vehicleProvider.getAvailableForDriver();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : MasterScreen(
            "Driver vehicle details", Column(children: [_buildContent()]));
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Text(
              "Assign Vehicle to Driver",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),

          // Driver dropdown
          Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(
                          "Select Driver",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenu<Driver>(
                    width: MediaQuery.of(context).size.width - 100,
                    enableSearch: true,
                    enableFilter: true,
                    initialSelection: _selectedDriver,
                    onSelected: (value) {
                      setState(() {
                        _selectedDriver = value;
                      });
                    },
                    dropdownMenuEntries: drivers?.result
                            .map((x) => DropdownMenuEntry(
                                value: x,
                                label: "${x.user?.name} ${x.user?.surname}"))
                            .toList() ??
                        [],
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Vehicle dropdown
          Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.directions_car, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(
                          "Select Vehicle",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenu<Vehicle>(
                    width: MediaQuery.of(context).size.width - 100,
                    enableSearch: true,
                    enableFilter: true,
                    initialSelection: _selectedVehicle,
                    onSelected: (value) {
                      setState(() {
                        _selectedVehicle = value;
                      });
                    },
                    dropdownMenuEntries: vehicles?.result
                            .map((x) =>
                                DropdownMenuEntry(value: x, label: "${x.name}"))
                            .toList() ??
                        [],
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 40),

          // Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => DriverVehicleScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_back),
                  label: Text(
                    "Go back",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_selectedDriver == null || _selectedVehicle == null) {
                      AlertHelpers.showAlert(context, "Warning",
                          "Please choose driver and vehicle!");
                      return;
                    }
                    var request = {
                      "driverId": _selectedDriver?.id,
                      "vehicleId": _selectedVehicle?.id
                    };
                    bool? editConfirmation =
                        await AlertHelpers.editConfirmation(context,
                            entity: "Driver Vehicle");
                    if (editConfirmation == true) {
                      try {
                        driverVehicleProvider.insert(request);

                        ScaffoldHelpers.showScaffold(context,
                            "Vehicle successfully assigned to ${_selectedDriver?.user?.name} ${_selectedDriver?.user?.surname}");
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => DriverVehicleScreen(),
                          ),
                        );
                      } catch (e) {
                        ScaffoldHelpers.showScaffold(
                            context, "${e.toString()}");
                      }
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
