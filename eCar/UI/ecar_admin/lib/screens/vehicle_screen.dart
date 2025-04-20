import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/vehicle_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/vehicle_details_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/string_helpers.dart' as help;

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  int _currentPage = 0;
  int _totalPages = 1;
  int _pageSize = 8;
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
    _fetchData();
    super.didChangeDependencies();
  }

  Future<void> _fetchData() async {
    try {
      var filter = {
        'IsAvailable': selectedValue,
        'Page': _currentPage,
        'PageSize': _pageSize
      };
      result = await provider.get(filter: filter);
      setState(() {
        print("Count: ${result?.count}");
        _totalPages = (result!.count! / _pageSize).ceil();
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Vehicles",
        Container(
          child: Column(
            children: [_buildSearch(), _buildResultView(), _buildPagination()],
          ),
        ));
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: FormStyleHelpers.dropdownDecoration(
                labelText: "Availability Status",
                hintText: "Select availability",
              ),
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
              style: FormStyleHelpers.textFieldTextStyle(),
            ),
          ),
          SizedBox(width: 24),
          SizedBox(
            width: 120,
            child: ElevatedButton.icon(
              onPressed: () async {
                _currentPage = 0;
                _fetchData();
              },
              icon: Icon(Icons.search),
              label: Text("Search"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          SizedBox(
            width: 120,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => VehicleDetailsScreen()));
              },
              icon: Icon(Icons.add),
              label: Text("Add"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
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
                                  : Container(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                        "assets/images/no_image_placeholder.png",
                                        height: 100,
                                        width: 100,
                                      ),
                                    )),
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
                                      try {
                                        provider.delete(e.id);
                                        await Future.delayed(
                                            const Duration(seconds: 1));
                                        ScaffoldHelpers.showScaffold(context,
                                            "Item successfully deleted");
                                        result = await provider.get(filter: {
                                          'Page': _currentPage,
                                          'PageSize': _pageSize
                                        });
                                        setState(() {});
                                      } catch (e) {
                                        ScaffoldHelpers.showScaffold(
                                            context, "${e.toString()}");
                                      }
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

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.yellowAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 0 ? _goToPreviousPage : null,
            icon: Icon(
              Icons.arrow_left,
              color: _currentPage > 0 ? Colors.black : Colors.grey,
            ),
            tooltip: 'Previous Page',
          ),
          const SizedBox(width: 16),
          if (_totalPages > 0) ...[
            Text(
              '${_currentPage + 1} of $_totalPages',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else if (_totalPages == 0) ...[
            Text(
              '0 of 0',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
          const SizedBox(width: 16),
          IconButton(
            onPressed: _currentPage < _totalPages - 1 ? _goToNextPage : null,
            icon: Icon(
              Icons.arrow_right,
              color:
                  _currentPage < _totalPages - 1 ? Colors.black : Colors.grey,
            ),
            tooltip: 'Next Page',
          ),
        ],
      ),
    );
  }

  void _goToNextPage() async {
    if (_currentPage < _totalPages - 1) {
      setState(() => _currentPage++);
      await _fetchData();
    } else {
      AlertHelpers.showAlert(context, "Warning", "Something went wrong!");
    }
  }

  void _goToPreviousPage() async {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      await _fetchData();
    } else {
      AlertHelpers.showAlert(context, "Warning", "Something went wrong!");
    }
  }
}
