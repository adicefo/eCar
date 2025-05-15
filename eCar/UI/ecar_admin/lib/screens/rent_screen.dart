import 'package:ecar_admin/models/Rent/rent.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/rent_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/rent_details_screen.dart';
import 'package:ecar_admin/screens/rent_request_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  late RentProvider provider;
  String? _selectedStatus;
  SearchResult<Rent>? result;

  int _currentPage = 0;
  int _pageSize = 8;
  int _totalPages = 1;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    provider = context.read<RentProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      result = null; // Clear current results to show loading indicator
    });

    try {
      var filter = {
        'Status': _selectedStatus,
        'Page': _currentPage,
        'PageSize': _pageSize
      };
      result = await provider.get(filter: filter);
      setState(() {
        if (result != null && result!.count != null) {
          _totalPages = (result!.count! / _pageSize).ceil();
          if (_totalPages < 1) _totalPages = 1;
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
        "Rent",
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
              "Search Rentals",
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
                      labelText: 'Rent Status',
                      hintText: 'Select status',
                    ),
                    value: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All')),
                      DropdownMenuItem(value: 'wait', child: Text('Wait')),
                      DropdownMenuItem(value: 'active', child: Text('Active')),
                      DropdownMenuItem(
                          value: 'finished', child: Text('Finished')),
                    ],
                    style: FormStyleHelpers.textFieldTextStyle(),
                  ),
                ),
                SizedBox(width: 24),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        _currentPage = 0;
                      });
                      await _fetchData();
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RentDetailsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
    if (result == null || result!.result.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.car_rental,
                size: 64,
                color: Colors.black26,
              ),
              SizedBox(height: 16),
              Text(
                "No rentals found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Try adjusting your search criteria",
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
                    "Rentals List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (result != null && result!.count != null)
                    Text(
                      "${result!.result.length} of ${result!.count} rentals",
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
                            width: 90,
                            child: Text("Start Date"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 90,
                            child: Text("End Date"),
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
                            width: 80,
                            child: Text("Status"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 100,
                            child: Text("Vehicle"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 120,
                            child: Text("Client"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 120,
                            child: Text("Actions"),
                          ),
                        ),
                      ],
                      rows: result!.result.asMap().entries.map((entry) {
                        int idx = entry.key;
                        Rent e = entry.value;

                        // Determine status color
                        Color statusColor = Colors.grey.shade700;
                        if (e.status == "wait")
                          statusColor = Colors.orange.shade700;
                        if (e.status == "active")
                          statusColor = Colors.green.shade700;
                        if (e.status == "finished")
                          statusColor = Colors.blue.shade700;

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
                                e.rentingDate.toString().substring(0, 10),
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.endingDate.toString().substring(0, 10),
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                "${e.fullPrice.toString()} KM",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: statusColor, width: 1),
                                ),
                                child: Text(
                                  e.status!.toUpperCase(),
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
                                e.vehicle!.name ?? "-",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                "${e.client?.user?.name ?? ''} ${e.client?.user?.surname ?? ''}",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  if (e.status == "wait")
                                    IconButton(
                                      icon: Icon(Icons.play_arrow,
                                          color: Colors.blue),
                                      tooltip: "Activate rent",
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RentRequestScreen(rent: e),
                                          ),
                                        );
                                      },
                                    )
                                  else
                                    IconButton(
                                      icon: Icon(Icons.play_arrow,
                                          color: Colors.grey),
                                      tooltip: "Status not 'wait'",
                                      onPressed: () {
                                        AlertHelpers.showAlert(
                                          context,
                                          "Invalid action",
                                          "Unable operation. Your status is not 'wait'!",
                                        );
                                      },
                                    ),
                                  if (e.status != "finished")
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      tooltip: "Edit rent",
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RentDetailsScreen(rent: e),
                                          ),
                                        );
                                      },
                                    )
                                  else
                                    IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.grey),
                                      tooltip: "Cannot edit finished rent",
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
                                    tooltip: "Delete rent",
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
                                              "Rent successfully deleted");
                                          await _fetchData();
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
