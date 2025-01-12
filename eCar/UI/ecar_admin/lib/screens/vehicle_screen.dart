import 'dart:ffi';

import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/vehicle_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/vehicle_details_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/string_helpers.dart' as help;

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  late VehicleProvider provider;
  final Map<String, bool> availabilityOptions = {
    'Available': true,
    'Unavailable': false,
  };
  String? selectedOption;
  bool? selectedValue;
  SearchResult<Vehicle>? result;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    provider = context.read<VehicleProvider>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Vehicle",
        Container(
          child: Column(
            children: [_buildSearch(), _buildResultView()],
          ),
        ));
  }

  Widget _buildSearch() {
    return Row(
      children: [
        SizedBox(
          width: 50,
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: DropdownButtonFormField<String>(
                isDense: true,
                focusColor: const Color.fromARGB(255, 255, 255, 255),
                decoration: InputDecoration(
                    labelText: "availability",
                    labelStyle: TextStyle(fontSize: 20)),
                value: selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedOption = newValue;
                    selectedValue = availabilityOptions[newValue];
                  });
                },
                items: availabilityOptions.keys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key),
                  );
                }).toList(),
              )),
        ),
        SizedBox(
          width: 200,
        ),
        SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () async {
                var filter = {'IsAvailable': selectedValue};
                result = await provider.get(filter: filter);

                setState(() {});

                print(result);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
              ),
              child: Text("Search"),
            ),
          ),
        ),
        SizedBox(width: 100),
        SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => VehicleDetailsScreen()));
              },
              child: Text("Add"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
              ),
            ),
          ),
        ),
        SizedBox(width: 50),
      ],
    );
  }

  Widget _buildResultView() {
    return Expanded(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            color: Colors.white,
            child: DataTable(
              columnSpacing: 25,
              columns: [
                DataColumn(
                    label: Text("ID",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Available",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Average consumption",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Name",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Image",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Price",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Edit",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Delete",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
              ],
              rows: result?.result
                      .map((e) => DataRow(
                            color: WidgetStateProperty<
                                Color?>.fromMap(<WidgetStatesConstraint, Color?>{
                              WidgetState.hovered & WidgetState.focused:
                                  Colors.blueGrey,
                              ~WidgetState.disabled: Colors.grey,
                            }),
                            cells: [
                              DataCell(Text(e.id.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(e.available.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(
                                  "${e.averageConsumption.toString()} l/km",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(e.name.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(e.image != null
                                  ? Container(
                                      width: 100,
                                      height: 100,
                                      child: help.StringHelpers
                                          .imageFromBase64String(e.image!),
                                    )
                                  : Text("null")),
                              DataCell(Text("${e.price.toString()}KM",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VehicleDetailsScreen(vehicle: e),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.yellowAccent),
                                  ),
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () async {
                                    bool? confirmDelete =
                                        await AlertHelpers.deleteConfirmation(
                                            context);
                                    if (confirmDelete == true) {
                                      provider.delete(e.id);
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      result = await provider.get();
                                      setState(() {});
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.redAccent),
                                  ),
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ))
                      .toList()
                      .cast<DataRow>() ??
                  [],
            ),
          ),
        ),
      ),
    ));
  }
}
