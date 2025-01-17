import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/route_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/models/Route/route.dart' as Model;
import 'package:ecar_admin/screens/route_details_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:number_pagination/number_pagination.dart';

class RouteListScreen extends StatefulWidget {
  const RouteListScreen({super.key});

  @override
  State<RouteListScreen> createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  int _currentPage = 0; // Track the current page
  int _totalPages = 1; // Total pages (fetched from API)
  int _pageSize = 8;
  late RouteProvider provider;
  String? _selectedStatus;
  SearchResult<Model.Route>? result;
  @override
  void didChangeDependencies() {
    provider = context.read<RouteProvider>();
    _fetchData();
    super.didChangeDependencies();
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
    return Row(
      children: [
        SizedBox(width: 50),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: DropdownButtonFormField<String>(
                isDense: true,
                focusColor: const Color.fromARGB(255, 255, 255, 255),
                decoration: InputDecoration(
                    labelText: "Status", labelStyle: TextStyle(fontSize: 20)),
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
              )),
        ),
        SizedBox(width: 200),
        SizedBox(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () async {
                _currentPage = 0;
                await _fetchData();
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
                    builder: (context) => RouteDetailsScreen()));
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
                      label: Text("ID",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
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
                                  DataCell(Text(e.id.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
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
                                          provider.delete(e.id);
                                          await Future.delayed(
                                              const Duration(seconds: 1));
                                          result = await provider.get(filter: {
                                            'Status': _selectedStatus,
                                            'Page': _currentPage,
                                            'PageSize': _pageSize
                                          });
                                          setState(() {});
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
