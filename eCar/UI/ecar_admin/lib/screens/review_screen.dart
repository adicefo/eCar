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
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    provider = context.read<ReviewProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      result = null; // Clear current results to show loading indicator
    });

    try {
      var filter = {
        'ReviewedName':
            _nameController.text.isNotEmpty ? _nameController.text : null,
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
      "Reviews",
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
              "Search Reviews",
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
                      labelText: "Driver Name",
                      hintText: "Search by driver name",
                    ),
                    controller: _nameController,
                    style: FormStyleHelpers.textFieldTextStyle(),
                    onSubmitted: (_) => _fetchData(),
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
                Icons.star_border,
                size: 64,
                color: Colors.black26,
              ),
              SizedBox(height: 16),
              Text(
                "No reviews found",
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
                    "Reviews List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (result != null && result!.count != null)
                    Text(
                      "${result!.result.length} of ${result!.count} reviews",
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
                            width: 120,
                            child: Text("Driver"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 120,
                            child: Text("Client"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 80,
                            child: Text("Rating"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 180,
                            child: Text("Comment"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 120,
                            child: Text("Actions"),
                          ),
                        ),
                      ],
                      rows: result!.result.asMap().entries.map((entry) {
                        int idx = entry.key;
                        Review e = entry.value;

                        // Generate star rating visual
                        Widget ratingWidget = Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < e.value! ? Icons.star : Icons.star_border,
                              color:
                                  index < e.value! ? Colors.amber : Colors.grey,
                              size: 18,
                            );
                          }),
                        );

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
                                "${e.reviewed?.user?.name ?? ''} ${e.reviewed?.user?.surname ?? ''}",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                "${e.reviews?.user?.name ?? ''} ${e.reviews?.user?.surname ?? ''}",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(ratingWidget),
                            DataCell(
                              Tooltip(
                                message: e.description ?? "",
                                child: Text(
                                  e.description != null &&
                                          e.description!.length > 30
                                      ? "${e.description!.substring(0, 30)}..."
                                      : e.description ?? "",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    tooltip: "Edit review",
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReviewDetailsScreen(review: e),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    tooltip: "Delete review",
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
                                              "Review successfully deleted");
                                          result = await provider.get(filter: {
                                            'ReviewedName':
                                                _nameController.text.isNotEmpty
                                                    ? _nameController.text
                                                    : null,
                                          });
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
