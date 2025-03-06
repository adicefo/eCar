import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/driverVehicle_provider.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/vehicle_provider.dart';
import 'package:ecar_admin/screens/driverVehicle_screen.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
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
    driverProvider = context.read<DriverProvider>();
    vehicleProvider = context.read<VehicleProvider>();
    driverVehicleProvider = context.read<DriverVehicleProvider>();
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    drivers = await driverProvider.get();

    vehicles = await vehicleProvider.getAvailableForDriver();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : MasterScreen("Driver vehicle details",
            Column(children: [_buildContent(), _buildSaveBtn()]));
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300, // Adjust width as needed
            decoration: BoxDecoration(
              color: Colors.grey[300], // Light grey background
              borderRadius: BorderRadius.circular(8), // Rounded corners
              border: Border.all(color: Colors.grey), // Single visible border
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DropdownMenuTheme(
              data: DropdownMenuThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              child: DropdownMenu<Driver>(
                label: Text("Driver"),
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
              ),
            ),
          ),
          SizedBox(width: 50),
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DropdownMenuTheme(
              data: DropdownMenuThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              child: DropdownMenu<Vehicle>(
                label: Text("Vehicle"),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveBtn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DriverVehicleScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(300, 50),
            ),
            child: const Text("Go back"),
          ),
          SizedBox(
            width: 100,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_selectedDriver == null || _selectedVehicle == null) {
                AlertHelpers.showAlert(
                    context, "Warning", "Please choose driver and vehicle!");
                return;
              }
              var request = {
                "driverId": _selectedDriver?.id,
                "vehicleId": _selectedVehicle?.id
              };
              bool? editConfirmation =
                  await AlertHelpers.editConfirmation(context);
              if (editConfirmation == true) {
                try {
                  driverVehicleProvider.insert(request);

                  ScaffoldHelpers.showScaffold(context,
                      "Car assigned to ${_selectedDriver?.user?.name} ${_selectedDriver?.user?.surname}");
                  await Future.delayed(const Duration(seconds: 3));
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => DriverVehicleScreen(),
                    ),
                  );
                } catch (e) {
                  ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(300, 50),
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
