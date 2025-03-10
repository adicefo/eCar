import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/client_provider.dart';
import 'package:ecar_admin/screens/clients_details_screen.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});
  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  late ClientProvider provider;
  SearchResult<Client>? result;
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _surnameEditingController = TextEditingController();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    provider = context.read<ClientProvider>();
    _fetchData();
    super.didChangeDependencies();
  }

  Future<void> _fetchData() async {
    try {
      var filter = {
        'NameGTE': _nameEditingController.text ?? "",
        'SurnameGTE': _surnameEditingController.text ?? ""
      };
      result = await provider.get(filter: filter);
      setState(() {});
      print(result);
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Clients",
        Container(
            child: Column(
          children: [_buildSearch(), _buildResultView()],
        )));
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
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Name",
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 254, 254),
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0.5, horizontal: 5.0)),
                controller: _nameEditingController,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
        ),
        SizedBox(
          width: 50,
        ),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Surname",
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 254, 254),
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.5, horizontal: 5.0)),
                  controller: _surnameEditingController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ))),
        SizedBox(
          width: 100,
        ),
        SizedBox(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () async {
                _fetchData();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
              ),
              child: Text("Search"),
            ),
          ),
        ),
        SizedBox(width: 70),
        SizedBox(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ClientsDetailsScreen()));
              },
              child: Text("Add"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 50,
        ),
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
                      label: Text("Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Surname",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Username",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Email",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Telephone number",
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
                              fontWeight: FontWeight.bold)))
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
                                  DataCell(Text(e.user?.name ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.user?.surname ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.user?.userName ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.user?.email ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.user?.telephoneNumber ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ClientsDetailsScreen(client: e),
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
                                            result = await provider.get();
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
    ); /*Expanded(child: 
    SingleChildScrollView(child: 
    Padding(padding: const EdgeInsets.only(top:50.0),child: 
    Align(
      alignment: Alignment.center,
      child: Container(
        child: DataTable(
          columnSpacing: 25,
          columns: [
            DataColumn(
                      label: Text("ID",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Surname",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Username",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Email",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Telephone number",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),DataColumn(
                      label: Text("Edit",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Delete",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)))
          ],
          rows: 
            result?.result
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
                                  DataCell(Text(e.user?.name ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.user?.surname ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.user?.userName ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.user?.email ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.user?.telephoneNumber ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),DataCell(
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ClientsDetailsScreen(client: e),
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
                                        provider.delete(e.id);
                                        await Future.delayed(
                                            const Duration(seconds: 2));
                                        result = await provider.get();
                                        setState(() {});
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
          ],
        ),
      ).toList().cast<DataRow> ??[],
    ),
    ),
    ),
    ),),);*/
  }
}
