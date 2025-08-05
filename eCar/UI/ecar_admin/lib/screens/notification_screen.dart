import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/notification_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/notification_details_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecar_admin/models/Notification/notification.dart' as Model;
import 'package:ecar_admin/utils/string_helpers.dart' as help;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationProvider provider;

  final Map<String, bool> availabilityOptions = {
    'User': true,
    'Driver': false,
  };
  String? selectedOption;
  bool? selectedValue;
  TextEditingController _headingController = TextEditingController();
  SearchResult<Model.Notification>? result;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    provider = context.read<NotificationProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      result = null;
    });

    try {
      var filter = {
        'HeadingGTE':
            _headingController.text.isNotEmpty ? _headingController.text : null,
        'IsForClient': selectedValue
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
      "Notifications",
      Container(
        child: Column(
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
        ),
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
              "Search Notifications",
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
                      labelText: "Heading",
                      hintText: "Search by heading",
                    ),
                    controller: _headingController,
                    style: FormStyleHelpers.textFieldTextStyle(),
                    onSubmitted: (_) => _fetchData(),
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: FormStyleHelpers.dropdownDecoration(
                      labelText: "Notification Type",
                      hintText: "Select type",
                    ),
                    value: selectedOption,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption = newValue;
                        selectedValue = availabilityOptions[newValue];
                      });
                    },
                    items: availabilityOptions.keys.map((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                    style: FormStyleHelpers.textFieldTextStyle(),
                  ),
                ),
                SizedBox(
                    width: 120,
                    child: IconButton(
                      icon: Icon(Icons.refresh),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          _headingController.text = "";
                          selectedOption = null;
                          selectedValue = null;
                          _fetchData();
                        });
                      },
                    )),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      _fetchData();
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
                          builder: (context) => NotificationDetailsScreen()));
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
    if (result == null || result!.result.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_off_outlined,
                size: 64,
                color: Colors.black26,
              ),
              SizedBox(height: 16),
              Text(
                "No notifications found",
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
                    "Notifications List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (result != null)
                    Text(
                      "${result!.result.length} notifications shown",
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
                      dataRowMinHeight: 100,
                      dataRowMaxHeight: 100,
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
                            width: 120,
                            child: Text("Heading"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 140,
                            child: Text("Content"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 80,
                            child: Text("Image"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 80,
                            child: Text("Date"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 100,
                            child: Text("For"),
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
                            child: Text("Actions"),
                          ),
                        ),
                      ],
                      rows: result!.result.asMap().entries.map((entry) {
                        int idx = entry.key;
                        Model.Notification e = entry.value;

                        Color targetColor = e.isForClient == true
                            ? Colors.blue.shade700
                            : Colors.orange.shade700;
                        String targetText =
                            e.isForClient == true ? "Client" : "Driver";

                        Color statusColor = Colors.green.shade700;

                        String statusText = "Active";

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
                                e.heading != null
                                    ? (e.heading!.length > 15
                                        ? e.heading!.substring(0, 15) + "..."
                                        : e.heading!)
                                    : "-",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataCell(
                              Tooltip(
                                message: e.content_ ?? "",
                                child: Text(
                                  e.content_ != null
                                      ? (e.content_!.length > 25
                                          ? e.content_!.substring(0, 25) + "..."
                                          : e.content_!)
                                      : "-",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: e.image != null
                                    ? Container(
                                        width: 60,
                                        height: 60,
                                        child: help.StringHelpers
                                            .imageFromBase64String(e.image!),
                                      )
                                    : Container(
                                        width: 60,
                                        height: 60,
                                        child: Image.asset(
                                          "assets/images/no_image_placeholder.png",
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.addingDate != null
                                    ? e.addingDate.toString().substring(0, 10)
                                    : "-",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: targetColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: targetColor, width: 1),
                                ),
                                child: Text(
                                  targetText,
                                  style: TextStyle(
                                    color: targetColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
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
                                  statusText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    tooltip: "Edit notification",
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationDetailsScreen(
                                                  notification: e),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    tooltip: "Delete notification",
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
                                              "Notification successfully deleted");
                                          var filter = {
                                            'HeadingGTE': _headingController
                                                    .text.isNotEmpty
                                                ? _headingController.text
                                                : null,
                                            'IsForClient': selectedValue
                                          };
                                          result = await provider.get(
                                              filter: filter);
                                          setState(() {});
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
}
