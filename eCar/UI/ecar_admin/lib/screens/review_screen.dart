import 'package:ecar_admin/models/Review/review.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/review_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/review_details_screen.dart';
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
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Review",
        Column(
          children: [_buildSearch(), _buildResultView()],
        ));
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
                controller: _nameController,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              )),
        ),
        SizedBox(
          width: 100,
        ),
        SizedBox(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () async {
                var filter = {'ReviewedName': _nameController.text};
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
        SizedBox(width: 300),
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
                            color: Colors.black, fontWeight: FontWeight.bold))),
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
                    label: Text("Route id",
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
                              DataCell(Text(e.id.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
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
                              DataCell(Text("${e.description}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text("${e.routeId.toString()}",
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
                                    provider.delete(e.id);
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    result = await provider.get();
                                    setState(() {});
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
