import 'package:ecar_admin/models/DriverVehicle/driverVehicle.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/driverVehicle_provider.dart';
import 'package:ecar_admin/screens/driverVehicle_details_screen.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverVehicleScreen extends StatefulWidget {
  const DriverVehicleScreen({super.key});

  @override
  State<DriverVehicleScreen> createState() => _DriverVehicleScreenState();
}

class _DriverVehicleScreenState extends State<DriverVehicleScreen> {
  int _currentPage = 0;
  int _totalPages = 1;
  int _pageSize = 8;
  TextEditingController _driverNameController = TextEditingController();
  SearchResult<DriverVehicle>? data;

  late DriverVehicleProvider driverVehicleProvider;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    driverVehicleProvider = context.read<DriverVehicleProvider>();

    _initForm();
  }

  Future<void> _initForm() async {
    setState(() {
      isLoading = true;
      data = null; // Clear current results to show loading indicator
    });

    try {
      var filter = {
        'Page': _currentPage,
        'PageSize': _pageSize,
        'DriverName': _driverNameController.text.isNotEmpty
            ? _driverNameController.text
            : null,
      };
      data = await driverVehicleProvider.get(filter: filter);
      setState(() {
        isLoading = false;
        if (data != null && data!.count != null) {
          _totalPages = (data!.count! / _pageSize).ceil();
          if (_totalPages < 1) _totalPages = 1;
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Driver Vehicle",
        Column(
          children: [
            _buildSearch(),
            isLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                      ),
                    ),
                  )
                : _buildResultView(),
            if (!isLoading && data != null && data!.result.isNotEmpty)
              _buildPagination()
          ],
        ));
  }

  Widget _buildSearch() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search Vehicle Assignments",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _driverNameController,
                    decoration: FormStyleHelpers.searchFieldDecoration(
                      labelText: "Driver Name",
                      hintText: "Search by driver name",
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    onSubmitted: (_) {
                      setState(() => _currentPage = 0);
                      _initForm();
                    },
                  ),
                ),
                SizedBox(width: 24),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _currentPage = 0);
                      _initForm();
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
                  width: 160,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => DriverVehicleDetailsScreen()),
                      );
                    },
                    icon: Icon(Icons.add),
                    label: Text("Assign Vehicle"),
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
                IconButton(
                  onPressed: () {
                    AlertHelpers.showAlert(
                        context,
                        "Driver Vehicle Explanation",
                        "Driver Vehicle in 'eCar' app is an entity which includes Driver and Vehicle entities. It is used when Driver start his working day he is obliged to assign some car that he will use for that day. Once he finishes the day he must return the car.");
                  },
                  icon: Icon(Icons.info),
                  color: Colors.blue,
                  iconSize: 30,
                  tooltip: "Info",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    if (data == null || data!.result.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_car,
                size: 64,
                color: Colors.black26,
              ),
              SizedBox(height: 16),
              Text(
                "No vehicle assignments found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Try adjusting your search criteria or create a new assignment",
                style: TextStyle(
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Vehicle Assignment List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (data != null && data!.count != null)
                    Text(
                      "${data!.result.length} of ${data!.count} assignments",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DataTable(
                      headingRowColor:
                          MaterialStateProperty.all(Colors.grey.shade100),
                      dataRowHeight: 70,
                      columnSpacing: 24,
                      horizontalMargin: 16,
                      showBottomBorder: true,
                      dividerThickness: 1,
                      headingTextStyle: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      columns: [
                        DataColumn(
                          label: Container(
                            width: 140,
                            child: Text("Driver"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 120,
                            child: Text("Vehicle"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 120,
                            child: Text("Pickup Date"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 120,
                            child: Text("Dropoff Date"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 120,
                            child: Text("Actions"),
                          ),
                        ),
                      ],
                      rows: data!.result.asMap().entries.map((entry) {
                        int idx = entry.key;
                        DriverVehicle e = entry.value;
                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Colors.yellowAccent.withOpacity(0.1);
                              if (idx % 2 == 0) return Colors.grey.shade50;
                              return null;
                            },
                          ),
                          cells: [
                            DataCell(
                              Text(
                                "${e.driver?.user?.name} ${e.driver?.user?.surname}" ??
                                    " ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                "${e.vehicle?.name}" ?? " ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.datePickUp?.toString().substring(0, 16) ??
                                    DateTime.now().toString().substring(0, 16),
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.dateDropOff?.toString().substring(0, 16) ??
                                    DateTime.now().toString().substring(0, 16),
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.grey),
                                    tooltip: "Edit not available",
                                    onPressed: () {
                                      AlertHelpers.showAlert(context, "Warning",
                                          "You can not edit driver vehicle because this entity is only used to assign vehicle to driver. Thank you");
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    tooltip: "Delete assignment",
                                    onPressed: () async {
                                      bool? confirmDelete =
                                          await AlertHelpers.deleteConfirmation(
                                              context);
                                      if (confirmDelete == true) {
                                        try {
                                          driverVehicleProvider.delete(e.id);
                                          await Future.delayed(
                                              const Duration(seconds: 1));
                                          ScaffoldHelpers.showScaffold(context,
                                              "Assignment deleted successfully");
                                          await _initForm();
                                        } catch (e) {
                                          ScaffoldHelpers.showScaffold(
                                              context, "${e.toString()}");
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              size: 28,
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
              size: 28,
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
      await _initForm();
    } else {
      AlertHelpers.showAlert(
          context, "Warning", "You've reached the last page!");
    }
  }

  void _goToPreviousPage() async {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      await _initForm();
    } else {
      AlertHelpers.showAlert(
          context, "Warning", "You're already on the first page!");
    }
  }
}
