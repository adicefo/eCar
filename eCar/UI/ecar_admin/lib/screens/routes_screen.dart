import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/route_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/models/Route/route.dart' as Model;
import 'package:ecar_admin/screens/route_details_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteListScreen extends StatefulWidget {
  const RouteListScreen({super.key});

  @override
  State<RouteListScreen> createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  int _currentPage = 0;
  int _totalPages = 1;
  int _pageSize = 8;
  DateTime? selectedDate;
  late RouteProvider provider;
  String? _selectedStatus;
  SearchResult<Model.Route>? result;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<RouteProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var filter = {
        'Status': _selectedStatus,
        'Page': _currentPage,
        'PageSize': _pageSize,
        "StartDate": selectedDate
      };

      result = await provider.get(filter: filter);

      setState(() {
        if (result != null && result!.count != null) {
          _totalPages = (result!.count! / _pageSize).ceil();
          if (_totalPages < 1) _totalPages = 1;

          if (_currentPage >= _totalPages && _totalPages > 0) {
            _currentPage = _totalPages - 1;
            if (result!.result.length > _pageSize) {
              _fetchData();
              return;
            }
          }
        }
        isLoading = false;
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
      "Routes",
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
          if (!isLoading && result != null && result!.result.isNotEmpty)
            _buildPagination()
        ],
      ),
    );
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
              "Filter Routes",
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
                  child: DropdownButtonFormField<String>(
                    decoration: FormStyleHelpers.dropdownDecoration(
                      labelText: "Route Status",
                      hintText: "Select status",
                    ),
                    value: _selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                          value: null, child: Text("All statuses")),
                      DropdownMenuItem(value: "wait", child: Text("Wait")),
                      DropdownMenuItem(value: "active", child: Text("Active")),
                      DropdownMenuItem(
                          value: "finished", child: Text("Finished")),
                    ],
                    style: FormStyleHelpers.textFieldTextStyle(),
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Date",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        selectedDate == null
                            ? 'Choose the date'
                            : "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                SizedBox(
                    width: 120,
                    child: IconButton(
                      icon: Icon(Icons.refresh),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          selectedDate = null;
                          _selectedStatus = null;
                          _fetchData();
                        });
                      },
                    )),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _currentPage = 0;
                      _fetchData();
                    },
                    icon: Icon(Icons.filter_list),
                    label: Text("Filter"),
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
                          builder: (context) => RouteDetailsScreen()));
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
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
                    "Routes List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (result != null && result!.count != null)
                    Text(
                      "Showing ${result!.result.length} of ${result!.count} routes",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: _buildTableContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
            ),
            SizedBox(height: 16),
            Text(
              "Loading routes...",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (result == null || result!.result.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.route,
              size: 64,
              color: Colors.black26,
            ),
            SizedBox(height: 16),
            Text(
              "No routes found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Try adjusting your filter criteria",
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
            dataRowMinHeight: 60,
            dataRowMaxHeight: 80,
            columnSpacing: 24,
            horizontalMargin: 16,
            showBottomBorder: true,
            dividerThickness: 1,
            headingTextStyle: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            columns: [
              DataColumn(
                label: Container(
                  width: 100,
                  child: Text("Client"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 100,
                  child: Text("Driver"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 80,
                  child: Text("Status"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 120,
                  child: Text("Start Date"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 120,
                  child: Text("End Date"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 80,
                  child: Text("Duration"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 80,
                  child: Text("Distance"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 80,
                  child: Text("Price"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 100,
                  child: Text("Actions"),
                ),
              ),
            ],
            rows: result!.result.asMap().entries.map((entry) {
              int idx = entry.key;
              Model.Route e = entry.value;

              Color statusColor = Colors.grey.shade700;
              if (e.status == "active") statusColor = Colors.green.shade700;
              if (e.status == "wait") statusColor = Colors.orange.shade700;
              if (e.status == "finished") statusColor = Colors.blue.shade700;

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
                      e.client?.user?.name ?? "-",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.driver?.user?.name ?? "-",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor, width: 1),
                      ),
                      child: Text(
                        e.status?.toUpperCase() ?? "-",
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.startDate?.toString().substring(0, 16) ?? "-",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.endDate?.toString().substring(0, 16) ?? "-",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.duration?.toString() ?? "0",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.numberOfKilometars?.toString() ?? "0",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.fullPrice != null
                          ? "${e.fullPrice.toString()} KM"
                          : "0 KM",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        if (e.status != "finished")
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            tooltip: "Edit route",
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RouteDetailsScreen(route: e),
                                ),
                              );
                            },
                          )
                        else
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.grey),
                            tooltip: "Cannot edit finished route",
                            onPressed: () {
                              AlertHelpers.showAlert(
                                context,
                                "Invalid action",
                                "Unable operation. You cannot edit when your status is finished!",
                              );
                            },
                          ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          tooltip: "Delete route",
                          onPressed: () async {
                            bool? confirmDelete =
                                await AlertHelpers.deleteConfirmation(context);
                            if (confirmDelete == true) {
                              try {
                                await provider.delete(e.id);
                                ScaffoldHelpers.showScaffold(
                                    context, "Route successfully deleted");
                                _fetchData();
                              } catch (e) {
                                ScaffoldHelpers.showScaffold(
                                    context, "Error: ${e.toString()}");
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
    );
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
      AlertHelpers.showAlert(
          context, "Warning", "You've reached the last page!");
    }
  }

  void _goToPreviousPage() async {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      await _fetchData();
    } else {
      AlertHelpers.showAlert(
          context, "Warning", "You're already on the first page!");
    }
  }
}
