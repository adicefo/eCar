import 'package:ecar_admin/models/Admin/admin.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/admin_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  SearchResult<Admin>? data;
  TextEditingController _searchController = TextEditingController();
  late AdminProvider adminProvider;

  bool isLoading = true;
  @override
  void initState() {
    adminProvider = context.read<AdminProvider>();
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    setState(() {
      isLoading = true;
    });

    try {
      var filter = {
        'Username':
            _searchController.text.isNotEmpty ? _searchController.text : null,
      };
      data = await adminProvider.get(filter: filter);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Admin",
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
              "Search Administrators",
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
                    controller: _searchController,
                    decoration: FormStyleHelpers.searchFieldDecoration(
                      labelText: "Username",
                      hintText: "Search by username",
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    onSubmitted: (_) => _initForm(),
                  ),
                ),
                SizedBox(width: 24),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: _initForm,
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
                      AlertHelpers.showAlert(context, "Unauthorized access",
                          "Due to application restrictions ONLY SUPER ADMIN/DEVELOPER have access to this operation. Thank you.");
                    },
                    icon: Icon(Icons.admin_panel_settings),
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
    if (data == null || data!.result.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 64,
                color: Colors.black26,
              ),
              SizedBox(height: 16),
              Text(
                "No administrators found",
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
                    "Administrators List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (data != null && data!.count != null)
                    Text(
                      "${data!.result.length} of ${data!.count} administrators",
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
                            width: 100,
                            child: Text("Name"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 100,
                            child: Text("Surname"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 120,
                            child: Text("Username"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 180,
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
                            width: 120,
                            child: Text("Actions"),
                          ),
                        ),
                      ],
                      rows: data!.result.asMap().entries.map((entry) {
                        int idx = entry.key;
                        Admin e = entry.value;
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
                                e.user?.name ?? " ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.user?.surname ?? " ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.user?.userName ?? " ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.user?.email ?? " ",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.user?.telephoneNumber ?? " ",
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
                                    tooltip: "Edit administrator",
                                    onPressed: () {
                                      AlertHelpers.showAlert(
                                          context,
                                          "Unauthorized access",
                                          "Due to application restrictions ONLY SUPER ADMIN/DEVELOPER have access to this operation. Thank you.");
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    tooltip: "Delete administrator",
                                    onPressed: () {
                                      AlertHelpers.showAlert(
                                          context,
                                          "Unauthorized access",
                                          "Due to application restrictions ONLY SUPER ADMIN/DEVELOPER have access to this operation. Thank you.");
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
}
