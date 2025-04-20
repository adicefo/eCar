import 'package:ecar_admin/models/Review/review.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/review_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/review_details_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late ReviewProvider provider;

  SearchResult<Review>? result;
  TextEditingController _nameController = TextEditingController();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    provider = context.read<ReviewProvider>();
    _fetchData();
    super.didChangeDependencies();
  }

  Future<void> _fetchData() async {
    try {
      var filter = {'ReviewedName': _nameController.text ?? null};
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
        "Reviews",
        Column(
          children: [_buildSearch(), _buildResultView()],
        ));
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: FormStyleHelpers.searchFieldDecoration(
                labelText: "Driver Name",
                hintText: "Search by driver name",
              ),
              controller: _nameController,
              style: FormStyleHelpers.textFieldTextStyle(),
            ),
          ),
          SizedBox(width: 24),
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
                    builder: (context) => ReviewDetailsScreen()));
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
                    label: Text("Driver name",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("User name",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Value",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text("Description",
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
                                  "${e.reviewed?.user?.name} ${e.reviewed?.user?.surname}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(
                                  "${e.reviews?.user?.name} ${e.reviews?.user?.surname}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(e.value.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(
                                  e.description!.length > 50
                                      ? "${e.description.toString().substring(0, 50)}"
                                      : "${e.description}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReviewDetailsScreen(review: e),
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
                                      setState(() {});
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
}
