import 'package:ecar_admin/models/Rent/rent.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/rent_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/rent_details_screen.dart';
import 'package:ecar_admin/screens/rent_request_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
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
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    provider = context.read<RentProvider>();
    _fetchData();
    super.didChangeDependencies();
  }

  Future<void> _fetchData() async {
    try {
      var filter = {
        'Status': _selectedStatus,
        'Page': _currentPage,
        'PageSize': _pageSize
      };
      result = await provider.get(filter: filter);
      setState(() {
        _totalPages = (result!.count! / _pageSize).ceil();
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Rent",
        Column(
          children: [_buildSearch(), _buildResultView(), _buildPagination()],
        ));
  }

  Widget _buildSearch() {
    return Row(
      children: [
        const SizedBox(width: 50),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: DropdownButtonFormField<String>(
              isDense: true,
              focusColor: const Color.fromARGB(255, 255, 255, 255),
              decoration: const InputDecoration(
                  labelText: "Status", labelStyle: TextStyle(fontSize: 20)),
              value: _selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue;
                });
              },
              items: const [
                DropdownMenuItem(value: "wait", child: Text("Wait")),
                DropdownMenuItem(value: "active", child: Text("Active")),
                DropdownMenuItem(value: "finished", child: Text("Finished")),
              ],
            ),
          ),
        ),
        SizedBox(width: 200),
        SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () async {
                _currentPage = 0;
                _fetchData();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
              ),
              child: const Text("Search"),
            ),
          ),
        ),
        const SizedBox(width: 100),
        SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => RentDetailsScreen(),
                  ),
                );
              },
              child: const Text("Add"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
              ),
            ),
          ),
        ),
        const SizedBox(width: 50),
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
                    label: Text("RentingDate",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("EndingDate",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("FullPrice",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Status",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Vehicle name",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Client name",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Active",
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
                              DataCell(Text(
                                  e.rentingDate.toString().substring(0, 19),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(
                                  e.endingDate.toString().substring(0, 19),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text("${e.fullPrice.toString()} KM",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(e.status!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(e.vehicle!.name!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(
                                  "${e.client?.user?.name} ${e.client?.user?.surname}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () async {
                                    e.status == "wait"
                                        ? Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RentRequestScreen(rent: e),
                                            ),
                                          )
                                        : AlertHelpers.showAlert(
                                            context,
                                            "Invalid action",
                                            "Unabled operation. Your status is not wait!");
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blueAccent),
                                  ),
                                  child: Text(
                                    "Active",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RentDetailsScreen(rent: e),
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
                                        result = await provider.get();
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
