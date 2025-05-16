import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/Route/route.dart' as Model;
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/client_provider.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/route_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/routes_screen.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/place_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;

class RouteDetailsScreen extends StatefulWidget {
  Model.Route? route;

  RouteDetailsScreen({super.key, this.route});
  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  SearchResult<Client>? clientResult;
  SearchResult<Driver>? driverResult;

  late RouteProvider routeProvider;
  late ClientProvider clientProvider;
  late DriverProvider driverProvider;

  bool isLoading = true;

  //place search coordinates
  Map<String, double> sourceCoordinates = {
    'latitude': 0,
    'longitude': 0,
  };
  Map<String, double> destinationCoordinates = {
    'latitude': 0,
    'longitude': 0,
  };

  //place search controllers
  final sourceController = TextEditingController();
  final destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    routeProvider = context.read<RouteProvider>();
    clientProvider = context.read<ClientProvider>();
    driverProvider = context.read<DriverProvider>();

    _initialValue = {
      "sourcePoint_latitude": widget.route?.sourcePoint?.latitude.toString(),
      "sourcePoint_longitude": widget.route?.sourcePoint?.longitude.toString(),
      "destinationPoint_latitude":
          widget.route?.destinationPoint?.latitude.toString(),
      "destinationPoint_longitude":
          widget.route?.destinationPoint?.longitude.toString(),
      "clientId": widget.route?.clientId.toString(),
      "driverID": widget.route?.driverID.toString()
    };

    // initialize coordinates if editing
    if (widget.route != null) {
      sourceCoordinates = {
        'latitude': widget.route!.sourcePoint?.latitude ?? 0.0,
        'longitude': widget.route!.sourcePoint?.longitude ?? 0.0,
      };
      destinationCoordinates = {
        'latitude': widget.route!.destinationPoint?.latitude ?? 0.0,
        'longitude': widget.route!.destinationPoint?.longitude ?? 0.0,
      };
    }

    initForm();
  }

  @override
  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    try {
      clientResult = await clientProvider.get();
      driverResult = await driverProvider.get();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Route details",
        Column(
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : widget.route!=null?_buildForm(
                    getAddressFromLatLng(sourceCoordinates['latitude']!,
                        sourceCoordinates['longitude']!),
                    getAddressFromLatLng(destinationCoordinates['latitude']!,
                        destinationCoordinates['longitude']!)):_buildForm(null,null),
            SizedBox(height: 20),
            _save()
          ],
        ));
  }

  Widget _buildForm(Future<String>? sourceAddressEdit, Future<String>? destinationAddressEdit) {
    final bool isDisabled = widget.route != null;

    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Source Location",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            if (isDisabled) ...[
              Column(
                children: [
                  Container(
                    height: 45,
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      
                    ),
                    child:FutureBuilder<String>(
                      future: sourceAddressEdit,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          );
                        } else {
                          return Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          );
                        }
                      },
                    
                  ),
                  ),
                    
                  SizedBox(height:15),
                  Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Source point latitude",
                        prefixIcon:
                            Icon(Icons.location_on, color: Colors.black54),
                        fillColor: Colors.grey.shade100,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      name: "sourcePoint_latitude",
                      enabled: false,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Source point longitude",
                        prefixIcon:
                            Icon(Icons.location_on, color: Colors.black54),
                        fillColor: Colors.grey.shade100,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      name: "sourcePoint_longitude",
                      enabled: false,
                    ),
                  ),
                ],
              ),
                ],
              )
            ] else ...[
              PlaceSearchField(
                key: UniqueKey(),
                label: "Search for source location",
                hint: "Enter a location",
                onLocationSelected: (coords, address) {
                  print(
                      "Source coordinates selected: ${coords['latitude']}, ${coords['longitude']}");

                  if (coords['latitude'] == 0.0 && coords['longitude'] == 0.0) {
                    print("Warning: Source coordinates are zeros!");
                    return;
                  }

                  setState(() {
                    sourceCoordinates = {
                      'latitude': coords['latitude'] ?? 0.0,
                      'longitude': coords['longitude'] ?? 0.0,
                    };

                    print("Source coordinates updated: $sourceCoordinates");

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final latField =
                          _formKey.currentState?.fields['sourcePoint_latitude'];
                      final lngField = _formKey
                          .currentState?.fields['sourcePoint_longitude'];

                      if (latField != null && lngField != null) {
                        latField.didChange(
                            sourceCoordinates['latitude'].toString());
                        lngField.didChange(
                            sourceCoordinates['longitude'].toString());
                        print(
                            "Source form fields updated with: ${sourceCoordinates['latitude']}, ${sourceCoordinates['longitude']}");
                      } else {
                        print("Warning: Could not find source form fields");
                      }
                    });
                  });
                },
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: sourceCoordinates['latitude'] != 0 ||
                          sourceCoordinates['longitude'] != 0
                      ? Colors.green.shade800
                      : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      sourceCoordinates['latitude'] != 0 ||
                              sourceCoordinates['longitude'] != 0
                          ? Icons.check_circle
                          : Icons.place,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      sourceCoordinates['latitude'] != 0 ||
                              sourceCoordinates['longitude'] != 0
                          ? "Location Selected: ${sourceCoordinates['latitude']?.toStringAsFixed(6) ?? '0.0'}, ${sourceCoordinates['longitude']?.toStringAsFixed(6) ?? '0.0'}"
                          : "No Location Selected Yet",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 0,
                  child: FormBuilderTextField(
                    name: "sourcePoint_latitude",
                    initialValue: sourceCoordinates['latitude'].toString(),
                  ),
                ),
              ),
              Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 0,
                  child: FormBuilderTextField(
                    name: "sourcePoint_longitude",
                    initialValue: sourceCoordinates['longitude'].toString(),
                  ),
                ),
              ),
            ],
            SizedBox(height: 25),
            Text(
              "Destination Location",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            if (isDisabled) ...[
              Column(children: [
                Container(
                  height: 45,
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      
                    ),
                    child:FutureBuilder<String>(
                      future: destinationAddressEdit,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          );
                        } else {
                          return Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          );
                        }
                      },
                    
                  ),
                  ),
                  SizedBox(height: 15,),
                Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Destination point latitude",
                        prefixIcon:
                            Icon(Icons.location_on, color: Colors.black54),
                        fillColor: Colors.grey.shade100,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      name: "destinationPoint_latitude",
                      enabled: false,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Destination point longitude",
                        prefixIcon:
                            Icon(Icons.location_on, color: Colors.black54),
                        fillColor: Colors.grey.shade100,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      name: "destinationPoint_longitude",
                      enabled: false,
                    ),
                  ),
                ],
              ),
              ],)
            ] else ...[
              PlaceSearchField(
                key: UniqueKey(),
                label: "Search for destination location",
                hint: "Enter a location",
                onLocationSelected: (coords, address) {
                  print(
                      "Destination coordinates selected: ${coords['latitude']}, ${coords['longitude']}");

                  if (coords['latitude'] == 0.0 && coords['longitude'] == 0.0) {
                    print("Warning: Destination coordinates are zeros!");
                    return;
                  }

                  setState(() {
                    destinationCoordinates = {
                      'latitude': coords['latitude'] ?? 0.0,
                      'longitude': coords['longitude'] ?? 0.0,
                    };

                    print(
                        "Destination coordinates updated: $destinationCoordinates");

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final latField = _formKey
                          .currentState?.fields['destinationPoint_latitude'];
                      final lngField = _formKey
                          .currentState?.fields['destinationPoint_longitude'];

                      if (latField != null && lngField != null) {
                        latField.didChange(
                            destinationCoordinates['latitude'].toString());
                        lngField.didChange(
                            destinationCoordinates['longitude'].toString());
                        print(
                            "Destination form fields updated with: ${destinationCoordinates['latitude']}, ${destinationCoordinates['longitude']}");
                      } else {
                        print(
                            "Warning: Could not find destination form fields");
                      }
                    });
                  });
                },
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: destinationCoordinates['latitude'] != 0 ||
                          destinationCoordinates['longitude'] != 0
                      ? Colors.green.shade800
                      : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      destinationCoordinates['latitude'] != 0 ||
                              destinationCoordinates['longitude'] != 0
                          ? Icons.check_circle
                          : Icons.place,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      destinationCoordinates['latitude'] != 0 ||
                              destinationCoordinates['longitude'] != 0
                          ? "Location Selected: ${destinationCoordinates['latitude']?.toStringAsFixed(6) ?? '0.0'}, ${destinationCoordinates['longitude']?.toStringAsFixed(6) ?? '0.0'}"
                          : "No Location Selected Yet",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 0,
                  child: FormBuilderTextField(
                    name: "destinationPoint_latitude",
                    initialValue: destinationCoordinates['latitude'].toString(),
                  ),
                ),
              ),
              Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 0,
                  child: FormBuilderTextField(
                    name: "destinationPoint_longitude",
                    initialValue:
                        destinationCoordinates['longitude'].toString(),
                  ),
                ),
              ),
            ],
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: FormBuilderDropdown(
                    name: "driverID",
                    decoration: FormStyleHelpers.dropdownDecoration(
                      labelText: "Driver",
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    enabled: !isDisabled,
                    items: driverResult?.result!
                            .map((item) => DropdownMenuItem(
                                  value: item.id.toString(),
                                  child: Text(
                                    "${item.user?.name} ${item.user?.surname}",
                                  ),
                                ))
                            .toList() ??
                        [],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FormBuilderDropdown(
                    name: "clientId",
                    decoration: FormStyleHelpers.dropdownDecoration(
                      labelText: "Client",
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    enabled: !isDisabled,
                    items: clientResult?.result
                            .map((item) => DropdownMenuItem(
                                  value: item.id.toString(),
                                  child: Text(
                                    "${item.user?.name} ${item.user?.surname}",
                                  ),
                                ))
                            .toList() ??
                        [],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _save() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.route != null)
            IconButton(
              onPressed: () {
                help.AlertHelpers.showAlert(context, "Route edit explanation",
                    "In the eCar app, edit mode is used to change the route state(from 'wait' to 'active' or from 'active' to 'finished'). It is not used to edit the route details but those details are only used to read.");
              },
              icon: Icon(Icons.info),
              color: Colors.blue,
              iconSize: 30,
              tooltip: "Info",
            ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => RouteListScreen(),
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
          if (widget.route == null)
            ElevatedButton.icon(
              onPressed: () async {
                if (sourceCoordinates['latitude'] == 0 &&
                    sourceCoordinates['longitude'] == 0) {
                  ScaffoldHelpers.showScaffold(
                      context, "Please select a source location");
                  return;
                }

                if (destinationCoordinates['latitude'] == 0 &&
                    destinationCoordinates['longitude'] == 0) {
                  ScaffoldHelpers.showScaffold(
                      context, "Please select a destination location");
                  return;
                }

                if (!_formKey.currentState!.saveAndValidate()) {
                  return;
                }
                var formData = _formKey.currentState!.value;

                if (formData['driverID'] == null ||
                    formData['clientId'] == null) {
                  ScaffoldHelpers.showScaffold(
                      context, "Please select a driver and client");
                  return;
                }

                print(
                    "Source coordinates before request: ${sourceCoordinates['latitude']}, ${sourceCoordinates['longitude']}");
                print(
                    "Destination coordinates before request: ${destinationCoordinates['latitude']}, ${destinationCoordinates['longitude']}");

                var request = {
                  "sourcePoint": {
                    "longitude": sourceCoordinates['longitude']?.toDouble(),
                    "latitude": sourceCoordinates['latitude']?.toDouble(),
                    "srid": 4326
                  },
                  "destinationPoint": {
                    "longitude":
                        destinationCoordinates['longitude']?.toDouble(),
                    "latitude": destinationCoordinates['latitude']?.toDouble(),
                    "srid": 4326
                  },
                  "driverID": formData['driverID'],
                  "clientId": formData['clientId']
                };

                try {
                  print("Sending request: ${jsonEncode(request)}");
                  await routeProvider.insert(request);
                  ScaffoldHelpers.showScaffold(
                      context, "Route added successfully");
                  await Future.delayed(const Duration(seconds: 1));
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RouteListScreen(),
                    ),
                  );
                } catch (e) {
                  ScaffoldHelpers.showScaffold(context, "${e.toString()}");
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
          if (widget.route?.status == "wait")
            ElevatedButton.icon(
              onPressed: () async {
                bool? confirmActive = await help.AlertHelpers.activeConfirmation(
                    context,
                    entity: "Route");
                if (confirmActive == true) {
                  try {
                    routeProvider.update(widget.route?.id,{});
                    ScaffoldHelpers.showScaffold(
                        context, "Route updated to active");
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => RouteListScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: Icon(Icons.airplanemode_active),
              label: const Text("Active"),
            ),
          if (widget.route?.status == "active")
            ElevatedButton.icon(
              onPressed: () async {
                bool? confirmFinish = await help.AlertHelpers.finishConfirmation(
                    context,
                    entity: "Route");
                if (confirmFinish == true) {
                  try {
                    routeProvider.updateFinish(widget.route?.id);
                    ScaffoldHelpers.showScaffold(
                        context, "Route updated to finish");
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => RouteListScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: Icon(Icons.check),
              label: const Text("Finish"),
            ),
        ],
      ),
    );
  }
}
