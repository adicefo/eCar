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
import 'package:number_pagination/number_pagination.dart';

class RouteListScreen extends StatefulWidget {
  const RouteListScreen({super.key});

  @override
  State<RouteListScreen> createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  int _currentPage = 0; //track the current page
  int _totalPages = 1; //total pages (fetched from API)
  int _pageSize = 8;
  late RouteProvider provider;
  String? _selectedStatus;
  SearchResult<Model.Route>? result;
  @override
  void didChangeDependencies() {
    provider = context.read<RouteProvider>();
    super.didChangeDependencies();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Routes",
        Container(
            child: Column(
          children: [_buildSearch(), _buildResultView(), _buildPagination()],
        )));
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
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
                DropdownMenuItem(value: "wait", child: Text("Wait")),
                DropdownMenuItem(value: "active", child: Text("Active")),
                DropdownMenuItem(value: "finished", child: Text("Finished")),
              ],
              style: FormStyleHelpers.textFieldTextStyle(),
            ),
          ),
          SizedBox(width: 24),
          SizedBox(
            width: 120,
            child: ElevatedButton.icon(
              onPressed: () async {
                _currentPage = 0;
                await _fetchData();
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
    );
  }

  Widget _buildResultView() {
    if (result == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (result!.result == null) {
      return const Center(child: Text("No routes found"));
    }
    if (result!.count == null) {
      return Container(
        child: Text(
          "Error",
          style: TextStyle(color: Colors.amber),
        ),
      );
    }
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
                      label: Text("Client name",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Driver name",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Status",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Start date",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("End date",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Duration",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Number of kilometars",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Full price",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Edit",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Delete",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
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
                                  DataCell(Text(e.client?.user?.name ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.driver?.user?.name ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.status ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(
                                      e.startDate
                                              ?.toString()
                                              .substring(0, 19) ??
                                          DateTime.now()
                                              .toString()
                                              .substring(0, 19),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(
                                      e.endDate?.toString().substring(0, 19) ??
                                          DateTime.now()
                                              .toString()
                                              .substring(0, 19),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.duration?.toString() ?? "0",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(
                                      e.numberOfKilometars?.toString() ?? "0",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(
                                      e.fullPrice != null
                                          ? "${e.fullPrice.toString()} KM"
                                          : "0KM",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RouteDetailsScreen(route: e),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
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
                                        bool? confirmDelete = await AlertHelpers
                                            .deleteConfirmation(context);
                                        if (confirmDelete == true) {
                                          try {
                                            provider.delete(e.id);
                                            await Future.delayed(
                                                const Duration(seconds: 1));
                                            ScaffoldHelpers.showScaffold(
                                                context,
                                                "Item successfully deleted");
                                            result = await provider.get(
                                                filter: {
                                                  'Status': _selectedStatus,
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
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.redAccent),
                                      ),
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ]))
                        .toList()
                        .cast<DataRow>() ??
                    [],
              ),
            ),
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

  Future<void> _fetchData() async {
    try {
      var filter = {
        'Status': _selectedStatus,
        'Page': _currentPage,
        'PageSize': _pageSize,
      };

      result = await provider.get(filter: filter);
      setState(() {
        print("Count ${result!.count!}");
        _totalPages = (result!.count! / _pageSize).ceil();
        print(_totalPages);
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
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
