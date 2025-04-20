import 'package:ecar_admin/models/Statistics/statistics.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/statistics_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/statistics_detail_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _currentPage = 0;
  int _totalPages = 1;
  int _pageSize = 8;

  SearchResult<Statistics>? data;

  late StatisticsProvider statisticsProvider;

  bool isLoading = true;

  @override
  void initState() {
    statisticsProvider = context.read<StatisticsProvider>();
    super.initState();

    _initForm();
  }

  Future<void> _initForm() async {
    try {
      var filter = {'Page': _currentPage, 'PageSize': _pageSize};
      data = await statisticsProvider.get(filter: filter);

      setState(() {
        isLoading = false;
        print("Count: ${data?.count}");
        _totalPages = (data!.count! / _pageSize).ceil();
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : MasterScreen(
            "Statistics",
            Container(
                child: Column(
              children: [
                _buildAddBtn(),
                _buildResultView(),
                _buildPagination()
              ],
            )));
  }

  Widget _buildAddBtn() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              AlertHelpers.showAlert(context, "Statistics Explanation",
                  "Generally, in the eCar app, the Statistics entity contains valuable information about the driver module. The application's concept is that a driver, as a company member, should be logged in once per each working day, which represents one statistics row. It contains columns such as the number of clients and the number of hours, which are necessary for the statistics function in the mobile app.");
            },
            icon: Icon(Icons.info),
            color: Colors.blue,
            iconSize: 30,
            tooltip: "Info",
          ),
          SizedBox(width: 16),
          SizedBox(
            width: 220,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => StatisticsDetailScreen(),
                  ),
                );
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
          padding: const EdgeInsets.only(top: 20.0),
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
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Driver surname",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Work begin",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Work end",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Hours num",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Clients num",
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
                rows: data?.result
                        .map((e) => DataRow(
                                color: WidgetStateProperty<
                                    Color?>.fromMap(<WidgetStatesConstraint, Color?>{
                                  WidgetState.hovered & WidgetState.focused:
                                      Colors.blueGrey,
                                  ~WidgetState.disabled: Colors.grey,
                                }),
                                cells: [
                                  DataCell(Text(e.driver?.user?.name ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(e.driver?.user?.surname ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(
                                      e.beginningOfWork
                                              ?.toString()
                                              .substring(0, 19) ??
                                          DateTime.now()
                                              .toString()
                                              .substring(0, 19),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(
                                      e.endOfWork
                                              ?.toString()
                                              .substring(0, 19) ??
                                          DateTime.now()
                                              .toString()
                                              .substring(0, 19),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(
                                      e.numberOfHours.toString() ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(
                                      e.numberOfClients.toString() ?? " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(
                                    ElevatedButton(
                                      onPressed: () {
                                        AlertHelpers.showAlert(
                                            context,
                                            "Warning",
                                            "This operation is not provided for admin(see mobile update logic ). You can either add new or delete row .");
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
                                          bool? confirmStatistics =
                                              await AlertHelpers
                                                  .deleteStatisticsConfirmation(
                                                      context);
                                          if (confirmStatistics == true) {
                                            try {
                                              statisticsProvider.delete(e.id);
                                              await Future.delayed(
                                                  const Duration(seconds: 1));
                                              data = await statisticsProvider
                                                  .get(filter: {
                                                'Page': _currentPage,
                                                'PageSize': _pageSize
                                              });
                                              setState(() {});
                                            } catch (e) {
                                              ScaffoldHelpers.showScaffold(
                                                  context, "${e.toString()}");
                                            }
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

  void _goToNextPage() async {
    if (_currentPage < _totalPages - 1) {
      setState(() => _currentPage++);
      await _initForm();
    } else {
      AlertHelpers.showAlert(context, "Warning", "Something went wrong!");
    }
  }

  void _goToPreviousPage() async {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      await _initForm();
    } else {
      AlertHelpers.showAlert(context, "Warning", "Something went wrong!");
    }
  }
}
