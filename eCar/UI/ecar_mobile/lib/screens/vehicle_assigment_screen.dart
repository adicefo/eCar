import 'package:ecar_mobile/models/Driver/driver.dart';
import 'package:ecar_mobile/models/DriverVehicle/driverVehicle.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/Vehicle/vehicle.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/driverVehicle_provider.dart';
import 'package:ecar_mobile/providers/driver_provider.dart';
import 'package:ecar_mobile/providers/vehicle_provider.dart';
import 'package:ecar_mobile/screens/notification_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:ecar_mobile/utils/string_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class VehicleAssigmentScreen extends StatefulWidget {
  User? user;
  VehicleAssigmentScreen({super.key, this.user});

  @override
  State<VehicleAssigmentScreen> createState() => _VehicleAssigmentScreenState();
}

class _VehicleAssigmentScreenState extends State<VehicleAssigmentScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValues = {};

  late DriverProvider driverProvider;
  late DriverVehicleProvider driverVehicleProvider;
  late VehicleProvider vehicleProvider;

  SearchResult<Driver>? driver = null;
  Driver? driverInstance = null;
  SearchResult<Vehicle>? vehicles = null;
  DriverVehicle? driverVehicleInstance = null;
  bool isLoading = true;

  String? _selectedImage = null;
  @override
  void initState() {
    // TODO: implement initState
    driverProvider = context.read<DriverProvider>();
    driverVehicleProvider = context.read<DriverVehicleProvider>();
    vehicleProvider = context.read<VehicleProvider>();
    _initialValues = {"driverId": 0, "vehicleId": 0};
    super.initState();
    _initForm();
  }

  Future _initForm() async {
    try {
      var filterDriver = {
        "NameGTE": widget.user?.name,
        "SurnameGTE": widget.user?.surname,
      };
      driver = await driverProvider.get(filter: filterDriver);

      driverInstance = driver?.result?.first;

      vehicles = await vehicleProvider.getAvailableForDriver();

      setState(() {
        print("Successful cars num: ${vehicles?.count}");
        isLoading = false;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Home",
              style: vehicles == null
                  ? TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)
                  : TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: vehicles == null ? Colors.black : Colors.white,
        body: isLoading ? getisLoadingHelper() : _buildScreen());
  }

  Widget _buildScreen() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValues,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (vehicles != null && vehicles!.result.isNotEmpty) ...[
              Row(children: [
                IconButton(onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(false),
                  ),
                );
              }, icon: Icon(Icons.arrow_back,size: 30, color: Colors.black87)),
                Padding(padding: EdgeInsets.only(left: 20),
                child: Text(
                "Choose the vehicle: ",
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              ],),
              SizedBox(height: 20),
              FormBuilderDropdown(
                name: 'vehicleId',
                initialValue: vehicles?.result.first.id.toString(),
                decoration: InputDecoration(
                  labelText: 'Vehicle',
                  filled: true,
                  fillColor: Colors.yellowAccent,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                items: vehicles!.result
                    .map((item) => DropdownMenuItem(
                          value: item.id.toString(),
                          child: Text(
                            "${item.name}",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ))
                    .toList(),
                validator: FormBuilderValidators.required(),
                onChanged: (value) {
                  final selectedVehicle = vehicles?.result.firstWhere(
                    (item) => item.id.toString() == value,
                  );
                  setState(() {
                    _selectedImage = selectedVehicle?.image;
                  });
                },
              ),
              SizedBox(height: 20),
              Container(
                child: _selectedImage == null
                    ? Container(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          "assets/images/no_image_placeholder.png",
                        ),
                      )
                    : StringHelpers.imageFromBase64String(_selectedImage),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      bool? isAssignedAlready = await driverVehicleProvider
                          .checkIfAssigned(driverInstance?.id);
                      if (isAssignedAlready) {
                        AlertHelpers.showAlert(context, "Error",
                            "You have already assigned car for today. If you want to assign again go to desktop app for DriverVehicles and delete row for current driver on today's date. Thank you.");
                        return;
                      }

                      if (_formKey.currentState?.validate() == false) {
                        AlertHelpers.showAlert(context, "Invalid form",
                            "Form is not valid. Please fix the values");
                        return;
                      }
                      bool? confirmEdit = await AlertHelpers.vehicelAssignmentConfirmation(
                          context);
                      if (confirmEdit == true) {
                        _formKey.currentState?.save();
                        var formData = _formKey.currentState?.value;
                        var request = {
                          "driverId": driverInstance?.id,
                          "vehicleId": formData!['vehicleId']
                        };
                        try {
                          driverVehicleProvider.insert(request);
                          ScaffoldHelpers.showScaffold(
                              context, "Successful assigned vehicle");
                        } catch (e) {
                          ScaffoldHelpers.showScaffold(context,
                              "You have already assign car for today.");
                        }
                      }
                    },
                    child: Text("Assign"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool? confirmEdit = await AlertHelpers.vehicelReturnConfirmation(
                          context);
                      if (confirmEdit == true) {
                        var request = {
                          "driverId": driverInstance?.id,
                          "datePickUp": DateTime.now().toIso8601String(),
                        };
                        try {
                          driverVehicleInstance =
                              await driverVehicleProvider.updateFinish(request);
                          if (driverVehicleInstance == null) {
                            AlertHelpers.showAlert(context, "Info",
                                "Error. You either not asssigned the car or already assigned it for today");
                            return;
                          }
                          ScaffoldHelpers.showScaffold(
                              context, "Successfully returned vehicle.");
                          //check if update is valid
                        } catch (e) {
                          ScaffoldHelpers.showScaffold(
                              context, "${e.toString()}");
                        }
                      }
                    },
                    child: Text("Return"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                 
                ],
              ),
            ] else ...[
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Sorry... There is no available cars at the moment!\nTry later!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool? confirmEdit = await AlertHelpers.editConfirmation(
                      context,
                      text: "Are you sure that you want to return your car?");
                  if (confirmEdit == true) {
                    var request = {
                      "driverId": driverInstance?.id,
                      "datePickUp": DateTime.now().toIso8601String(),
                    };
                    try {
                      driverVehicleInstance =
                          await driverVehicleProvider.updateFinish(request);

                      AlertHelpers.showAlert(context, "Info",
                          "Vehicle successful returned. Go to logout page... ");
                    } catch (e) {
                      ScaffoldHelpers.showScaffold(context,
                          "Unsuccessful operation. Please first assign your car");
                    }

                    //check if update is valid
                  }
                },
                child: Text("Return"),
              ),
             
            ],
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
