import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/screens/driver_details_screen.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriversListScreen extends StatefulWidget {
  const DriversListScreen({super.key});

  @override
  State<DriversListScreen> createState() => _DriversListScreenState();
}

class _DriversListScreenState extends State<DriversListScreen> {
  late DriverProvider provider;
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _surnameEditingController = TextEditingController();
  SearchResult<Driver>? result;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    provider = context.read<DriverProvider>();
    _fetchData();
    super.didChangeDependencies();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var filter = {
        'NameGTE': _nameEditingController.text,
        'SurnameGTE': _surnameEditingController.text
      };
      result = await provider.get(filter: filter);
      setState(() {
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
        "Drivers",
        Container(
            child: Column(
          children: [_buildSearch(), _buildResultView()],
        )));
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
              "Search Drivers",
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
                    decoration: FormStyleHelpers.searchFieldDecoration(
                      labelText: "Name",
                      hintText: "Search by name",
                    ),
                    controller: _nameEditingController,
                    style: FormStyleHelpers.textFieldTextStyle(),
                    onSubmitted: (_) => _fetchData(),
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: TextField(
                    decoration: FormStyleHelpers.searchFieldDecoration(
                      labelText: "Surname",
                      hintText: "Search by surname",
                    ),
                    controller: _surnameEditingController,
                    style: FormStyleHelpers.textFieldTextStyle(),
                    onSubmitted: (_) => _fetchData(),
                  ),
                ),
                SizedBox(width: 24),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: _fetchData,
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
                          builder: (context) => DriverDetailsScreen()));
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
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                    "Drivers List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (result != null)
                    Text(
                      "${result!.result.length} drivers found",
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
              "Loading drivers...",
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
              Icons.person_off,
              size: 64,
              color: Colors.black26,
            ),
            SizedBox(height: 16),
            Text(
              "No drivers found",
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
            columnSpacing: 32,
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
                  width: 80,
                  child: Text("Name"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 80,
                  child: Text("Surname"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 100,
                  child: Text("Username"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 150,
                  child: Text("Email"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 120,
                  child: Text("Phone"),
                ),
              ),
              DataColumn(
                label: Container(
                  width: 80,
                  child: Text("Hours"),
                ),
                tooltip: "Number of driving hours",
              ),
              DataColumn(
                label: Container(
                  width: 80,
                  child: Text("Clients"),
                ),
                tooltip: "Number of clients served",
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
              Driver e = entry.value;
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
                      e.user?.name ?? "-",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.user?.surname ?? "-",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.user?.userName ?? "-",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.user?.email ?? "-",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.user?.telephoneNumber ?? "-",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.numberOfHoursAmount?.toString() ?? "0",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      e.numberOfClientsAmount?.toString() ?? "0",
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
                          icon: Icon(Icons.edit, color: Colors.blue),
                          tooltip: "Edit driver",
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    DriverDetailsScreen(driver: e),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          tooltip: "Delete driver",
                          onPressed: () async {
                            bool? confirmDelete =
                                await AlertHelpers.deleteConfirmation(context);
                            if (confirmDelete == true) {
                              try {
                                await provider.delete(e.id);
                                ScaffoldHelpers.showScaffold(
                                    context, "Driver successfully deleted");
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
}
