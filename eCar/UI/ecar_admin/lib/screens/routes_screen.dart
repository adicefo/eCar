import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/route_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/models/Route/route.dart' as Model;
import 'package:ecar_admin/screens/route_details_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteListScreen extends StatefulWidget {
  const RouteListScreen({super.key});

  @override
  State<RouteListScreen> createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  late RouteProvider provider;

  @override
  void didChangeDependencies() {
    provider = context.read<RouteProvider>();
    super.didChangeDependencies();
  }

  String? _selectedStatus;
  SearchResult<Model.Route>? result;
  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Routes",
        Container(
            child: Column(
          children: [_buildSearch(), _buildResultView()],
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
                var filter = {'Status': _selectedStatus};
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
                                      e.startDate?.toString() ??
                                          DateTime.now().toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(
                                      e.endDate?.toString() ??
                                          DateTime.now().toString(),
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
                                          result = await provider.get();
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
}
