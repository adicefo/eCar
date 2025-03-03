import 'dart:io';
import 'dart:typed_data';

import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/Review/review.dart';
import 'package:ecar_admin/models/Route/route.dart' as Model;
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/client_provider.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/review_provider.dart';
import 'package:ecar_admin/providers/route_provider.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:ecar_admin/utils/chart_helpers.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  GlobalKey chartKey = GlobalKey();

  Map<int, double> data2024 = {};
  Map<int, double> data2025 = {};

  int selectedIndex = 0;

  String? _selectedDriverOption;
  String? _selectedMonthRoute = null;
  String? _selectedYearRoute = null;
  String? _selectedMonthReview = null;
  String? _selectedYearReview = null;

  bool _drawForDriver = false;
  bool _drawForRoute = false;
  bool _drawForReview = false;
  bool _representHighLowReview = false;

  double? _routeTotalAmount;
  double _total2024 = 0.0;
  double _total2025 = 0.0;

  Map<String, dynamic>? _reviewReportObj = null;

  SearchResult<Driver>? drivers;
  SearchResult<Client>? clients;
  SearchResult<Model.Route>? routes;
  SearchResult<Review>? reviews;

  late DriverProvider driverProvider;
  late ClientProvider clientProvider;
  late RouteProvider routeProvider;
  late ReviewProvider reviewProvider;

  bool isLoading = true;
  @override
  void initState() {
    driverProvider = context.read<DriverProvider>();
    clientProvider = context.read<ClientProvider>();
    routeProvider = context.read<RouteProvider>();
    reviewProvider = context.read<ReviewProvider>();

    super.initState();
    _initForm();
    fetchYearlyData(2024).then((value) {
      setState(() {
        data2024 = value;
        isLoading = false;
      });
    });
    fetchYearlyData(2025).then((value) {
      setState(() {
        data2025 = value;
        isLoading = false;
      });
    });
  }

  Future<void> _initForm() async {
    drivers = await driverProvider.get();
    clients = await clientProvider.get();
    routes = await routeProvider.get();
    reviews = await reviewProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  Future<Map<int, double>> fetchYearlyData(int year) async {
    Map<int, double> data = {};
    for (int month = 1; month <= 12; month++) {
      var filter = {"Month": month, "Year": year};
      double amount = await routeProvider.getForReport(filter);
      data[month] = amount;
      year == 2024 ? _total2024 += amount : _total2025 += amount;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reports",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                _buildMenu(),
                Expanded(child: _buildContent()),
              ],
            ),
    );
  }

  Widget _buildMenu() {
    List<String> menuItems = ["Drivers", "Routes", "Reviews"];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(menuItems.length, (index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? Colors.yellowAccent
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                menuItems[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: selectedIndex == index ? Colors.black : Colors.grey,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent() {
    switch (selectedIndex) {
      case 0:
        return _buildDriversContent();
      case 1:
        return _buildRoutesContent();
      case 2:
        return _buildReviewsContent();

      default:
        return const Center(child: Text("Select a category"));
    }
  }

  Widget _buildDriversContent() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTextBoxCount("driver"),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 500,
          child: _buildDropdownMenuBtnDriver(),
        ),
        const SizedBox(
          height: 20,
        ),
        _drawDriverBarChart(),
        const SizedBox(
          height: 20,
        ),
        if (_drawForDriver) _drawExportPdfBtn("driver"),
      ],
    ));
  }

  Widget _buildDropdownMenuBtnDriver() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: DropdownButtonFormField<String>(
            isDense: true,
            focusColor: const Color.fromARGB(255, 255, 255, 255),
            decoration: const InputDecoration(
                labelText: "Filter by", labelStyle: TextStyle(fontSize: 20)),
            value: _selectedDriverOption,
            onChanged: (String? newValue) {
              setState(() {
                _selectedDriverOption = newValue;
              });
            },
            items: const [
              DropdownMenuItem(value: "hours", child: Text("Hours")),
              DropdownMenuItem(value: "clients", child: Text("Clients")),
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _drawForDriver = true;
            });
          },
          child: Text("Filter"),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(150, 50)),
        )
      ],
    );
  }

  Widget _drawDriverBarChart() {
    if (!_drawForDriver) {
      return Container(
        width: 350,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Bar chart is not represented.\nPlease select your filter.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    List<Driver> driverList = drivers!.result.toList();

    return RepaintBoundary(
      key: chartKey,
      child: Column(
        children: [
          Text(
            _selectedDriverOption == "clients"
                ? "Number of clients amount per each driver"
                : "Number of hours amount per each driver",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          AspectRatio(
            aspectRatio: 5,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(
                  show: true,
                  border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.deepPurple),
                  ),
                ),
                barGroups: List.generate(driverList.length, (index) {
                  return BarChartGroupData(x: index, barRods: [
                    if (_selectedDriverOption == "clients")
                      BarChartRodData(
                        toY:
                            driverList[index].numberOfClientsAmount!.toDouble(),
                        color: Colors.blue,
                        width: 12,
                      ),
                    if (_selectedDriverOption == "hours")
                      BarChartRodData(
                        toY: driverList[index].numberOfHoursAmount!.toDouble(),
                        color: Colors.blue,
                        width: 12,
                      )
                  ]);
                }),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  rightTitles: AxisTitles(
                      axisNameWidget: Text(
                        _selectedDriverOption == "clients"
                            ? "Number of clients"
                            : "Number of hours",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      sideTitles: SideTitles(showTitles: true)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        return Text(
                            "${driverList[index].user?.name} ${driverList[index].user?.surname}" ??
                                "Unknown");
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRoutesContent() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTextBoxCount("route"),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 750,
          child: _buildDropdownMenuRoute(),
        ),
        SizedBox(
          height: 20,
        ),
        _buildContainer(
            "Total amount is: ${_routeTotalAmount?.toString() ?? 0.0} KM",
            null),
        _buildTableBtnRoute(),
        if (_drawForRoute) _buildTableRoute(),
        if (_drawForRoute) _drawExportPdfBtn("route"),
      ],
    ));
  }

  Widget _buildDropdownMenuRoute() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: DropdownButtonFormField<String>(
            isDense: true,
            focusColor: const Color.fromARGB(255, 255, 255, 255),
            decoration: const InputDecoration(
                labelText: "Month", labelStyle: TextStyle(fontSize: 20)),
            value: _selectedMonthRoute,
            onChanged: (String? newValue) {
              setState(() {
                _selectedMonthRoute = newValue;
              });
            },
            items: const [
              DropdownMenuItem(value: "jan", child: Text("January")),
              DropdownMenuItem(value: "feb", child: Text("February")),
              DropdownMenuItem(value: "mar", child: Text("March")),
              DropdownMenuItem(value: "apr", child: Text("April")),
              DropdownMenuItem(value: "may", child: Text("May")),
              DropdownMenuItem(value: "jun", child: Text("June")),
              DropdownMenuItem(value: "jul", child: Text("July")),
              DropdownMenuItem(value: "aug", child: Text("August")),
              DropdownMenuItem(value: "sep", child: Text("September")),
              DropdownMenuItem(value: "oct", child: Text("October")),
              DropdownMenuItem(value: "nov", child: Text("November")),
              DropdownMenuItem(value: "dec", child: Text("December")),
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        SizedBox(
          width: 250,
          child: DropdownButtonFormField<String>(
            isDense: true,
            focusColor: const Color.fromARGB(255, 255, 255, 255),
            decoration: const InputDecoration(
                labelText: "Year", labelStyle: TextStyle(fontSize: 20)),
            value: _selectedYearRoute,
            onChanged: (String? newValue) {
              setState(() {
                _selectedYearRoute = newValue;
              });
            },
            items: const [
              DropdownMenuItem(value: "2024", child: Text("2024")),
              DropdownMenuItem(value: "2025", child: Text("2025")),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            if (_selectedMonthRoute == null || _selectedYearRoute == null) {
              AlertHelpers.showAlert(
                  context, "Info", "Please select month and year");
              return;
            }
            var filter = {
              "Month": _getMonthFromDropdown(_selectedMonthRoute!),
              "Year": int.parse(_selectedYearRoute!)
            };

            try {
              _routeTotalAmount = await routeProvider.getForReport(filter);
              setState(() {});
            } catch (e) {
              ScaffoldHelpers.showScaffold(context, "${e.toString()}");
            }
          },
          child: Text("Filter"),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(150, 50)),
        )
      ],
    );
  }

  Widget _buildTableBtnRoute() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: Size(200, 50),
          ),
          onPressed: () => {
                setState(() {
                  _drawForRoute = true;
                })
              },
          child: const Text("Show table")),
    );
  }

  Widget _buildTableRoute() {
    Map<int, double> data = _selectedYearRoute == "2025" ? data2025 : data2024;
    double total = _selectedYearRoute == "2025" ? _total2025 : _total2024;

    return DataTable(
      columnSpacing: 10,
      columns: [
        DataColumn(label: Text("January")),
        DataColumn(label: Text("February")),
        DataColumn(label: Text("March")),
        DataColumn(label: Text("April")),
        DataColumn(label: Text("May")),
        DataColumn(label: Text("June")),
        DataColumn(label: Text("July")),
        DataColumn(label: Text("August")),
        DataColumn(label: Text("September")),
        DataColumn(label: Text("October")),
        DataColumn(label: Text("November")),
        DataColumn(label: Text("December")),
        DataColumn(label: Text("Total")),
      ],
      rows: [
        DataRow(
          cells: List.generate(
            12,
            (index) => DataCell(
              Text("${data2024[index + 1]?.toStringAsFixed(2) ?? '0'} KM"),
            ),
          )..add(DataCell(Text("${_total2024.toStringAsFixed(2)} KM"))),
        ),
        DataRow(
          cells: List.generate(
            12,
            (index) => DataCell(
              Text("${data2025[index + 1]?.toStringAsFixed(2) ?? '0'} KM"),
            ),
          )..add(DataCell(Text("${_total2025.toStringAsFixed(2)} KM"))),
        ),
      ],
    );
  }

  Widget _buildReviewsContent() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTextBoxCount("review"),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 750,
          child: _buildDropdownMenuReview(),
        ),
        SizedBox(
          height: 20,
        ),
        if (_drawForReview)
          _buildContainer("There is no data for selected month and year", null),
        if (_representHighLowReview)
          _buildContainer(
              "Highest average mark has: ${_reviewReportObj!["maxDriver"]["driverName"]["name"]} ${_reviewReportObj!["maxDriver"]["driverName"]["surname"]}: ${_reviewReportObj!["maxDriver"]["avgMark"]}",
              null),
        SizedBox(
          height: 20,
        ),
        if (_representHighLowReview)
          _buildContainer(
              "Lowes average mark has: ${_reviewReportObj!["minDriver"]["driverName"]["name"]} ${_reviewReportObj!["minDriver"]["driverName"]["surname"]}: ${_reviewReportObj!["minDriver"]["avgMark"]}",
              null),
        if (_representHighLowReview) _drawExportPdfBtn("review")
      ],
    ));
  }

  Widget _buildDropdownMenuReview() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: DropdownButtonFormField<String>(
            isDense: true,
            focusColor: const Color.fromARGB(255, 255, 255, 255),
            decoration: const InputDecoration(
                labelText: "Month", labelStyle: TextStyle(fontSize: 20)),
            value: _selectedMonthReview,
            onChanged: (String? newValue) {
              setState(() {
                _selectedMonthReview = newValue;
              });
            },
            items: const [
              DropdownMenuItem(value: "jan", child: Text("January")),
              DropdownMenuItem(value: "feb", child: Text("February")),
              DropdownMenuItem(value: "mar", child: Text("March")),
              DropdownMenuItem(value: "apr", child: Text("April")),
              DropdownMenuItem(value: "may", child: Text("May")),
              DropdownMenuItem(value: "jun", child: Text("June")),
              DropdownMenuItem(value: "jul", child: Text("July")),
              DropdownMenuItem(value: "aug", child: Text("August")),
              DropdownMenuItem(value: "sep", child: Text("September")),
              DropdownMenuItem(value: "oct", child: Text("October")),
              DropdownMenuItem(value: "nov", child: Text("November")),
              DropdownMenuItem(value: "dec", child: Text("December")),
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        SizedBox(
          width: 250,
          child: DropdownButtonFormField<String>(
            isDense: true,
            focusColor: const Color.fromARGB(255, 255, 255, 255),
            decoration: const InputDecoration(
                labelText: "Year", labelStyle: TextStyle(fontSize: 20)),
            value: _selectedYearReview,
            onChanged: (String? newValue) {
              setState(() {
                _selectedYearReview = newValue;
              });
            },
            items: const [
              DropdownMenuItem(value: "2024", child: Text("2024")),
              DropdownMenuItem(value: "2025", child: Text("2025")),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            if (_selectedMonthReview == null || _selectedYearReview == null) {
              AlertHelpers.showAlert(
                  context, "Info", "Please select month and year");
              return;
            }
            var filter = {
              "Month": _getMonthFromDropdown(_selectedMonthReview!),
              "Year": int.parse(_selectedYearReview!)
            };

            try {
              _reviewReportObj = await reviewProvider.getForReport(filter);
              if (_reviewReportObj!["maxDriver"] == "null") {
                _drawForReview = true;
                _representHighLowReview = false;
              }
              if (_reviewReportObj!["maxDriver"] != "null") {
                _representHighLowReview = true;
                _drawForReview = false;
              }
              setState(() {});
            } catch (e) {
              ScaffoldHelpers.showScaffold(context, "${e.toString()}");
            }
          },
          child: Text("Filter"),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(150, 50)),
        )
      ],
    );
  }

  Widget _buildContainer(String hint, int? number) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      height: 50,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: number != null
            ? Text("$hint $number", style: const TextStyle(fontSize: 18))
            : Text("$hint", style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildTextBoxCount(String entity) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (entity == "driver")
        _buildContainer("Total number of drivers:", drivers?.count),
      if (entity == "route")
        _buildContainer("Total number of routes:", routes?.count),
      if (entity == "review")
        _buildContainer("Total number of reviews:", reviews?.count),
      const SizedBox(width: 20),
    ]);
  }

  Widget _drawExportPdfBtn(String entity) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: Size(200, 50),
          ),
          onPressed: () => _exportToPdf(entity),
          child: const Text("Export to PDF")),
    );
  }

  void _exportToPdf(String entity) async {
    final pdf = pw.Document();
    Uint8List? imageBytes = await captureChart(chartKey);

    pw.Table buildPdfTable(Map<int, double> data, int year) {
      return pw.Table.fromTextArray(
        headers: ['Month', 'Total Amount (KM)'],
        data: [
          ...data.entries //... separates each elemnt of the list in one row
              .map(
                  (e) => ["${e.key}/$year", "${e.value.toStringAsFixed(2)} KM"])
              .toList(),
          year == 2024
              ? ["Total", "${_total2024.toStringAsFixed(2)} KM"]
              : ["Total", "${_total2025.toStringAsFixed(2)} KM"]
        ],
      );
    }

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Container(
                child: pw.Image(pw.MemoryImage(
                    File('assets/images/55283.png').readAsBytesSync())),
                height: 50),
            pw.Text(
              'eCar Report for ${entity.toUpperCase()}',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
                'In the following document you can see some key information about ${entity.toUpperCase()} based business '),
            pw.SizedBox(height: 10),
            if (entity == "driver")
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                      'Number of drivers in the database: ${drivers!.count}'),
                  pw.Text(
                      'Number of clients in the database: ${clients!.count}'),
                  pw.SizedBox(height: 20),
                ],
              ),
            if (entity == "driver") ...[
              pw.Text('Business Quantity Chart per Driver'),
              pw.SizedBox(height: 10),
              if (imageBytes != null)
                pw.Image(pw.MemoryImage(imageBytes), height: 200),
            ],
            if (entity == "route") ...[
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Number of routes in the database: ${routes!.count}'),
                  pw.SizedBox(height: 20),
                ],
              ),
              pw.Text("Yearly Report 2024",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              buildPdfTable(data2024, 2024),
            ],
            if (entity == "review") ...[
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                      'Number of reviews in the database: ${reviews!.count}'),
                  pw.SizedBox(
                    height: 20,
                  ),
                  pw.Text(
                      'Number of drivers in the database: ${drivers!.count}'),
                  pw.SizedBox(
                    height: 20,
                  ),
                  pw.Text(
                      'Number of clients in the database: ${clients!.count}'),
                  pw.SizedBox(height: 40),
                ],
              ),
              pw.Text("Driver reviwes report",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text(
                "For the month of ${_getMonthForReport(_selectedMonthReview!)} year ${_selectedYearReview} here are the extrems for drivers reviews:",
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                  "Highest average mark has  ${_reviewReportObj!["maxDriver"]["driverName"]["name"]} ${_reviewReportObj!["maxDriver"]["driverName"]["surname"]} with value of: ${_reviewReportObj!["maxDriver"]["avgMark"]}"),
              pw.SizedBox(height: 20),
              pw.Text(
                  "Lowest average mark has  ${_reviewReportObj!["minDriver"]["driverName"]["name"]} ${_reviewReportObj!["minDriver"]["driverName"]["surname"]} with value of: ${_reviewReportObj!["minDriver"]["avgMark"]}"),
            ]
          ],
        ),
      ),
    );

    if (entity == "route") {
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            children: [
              pw.Text("Yearly Report 2025",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              buildPdfTable(data2025, 2025),
            ],
          ),
        ),
      );
    }

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save PDF Report',
      initialDirectory: "/",
      allowedExtensions: ['pdf'],
      fileName: entity == "driver"
          ? "ecar_report_driver.pdf"
          : entity == "route"
              ? "ecar_report_route.pdf"
              : entity == "review"
                  ? "ecar_report_review.pdf"
                  : "ecar_report_default.pdf",
    );

    if (result != null) {
      final file = File(result);
      await file.writeAsBytes(await pdf.save());
    }
  }

  int _getMonthFromDropdown(String _selectedMonth) {
    switch (_selectedMonth) {
      case "jan":
        return 1;
      case "feb":
        return 2;
      case "mar":
        return 3;
      case "apr":
        return 4;
      case "may":
        return 5;
      case "jun":
        return 6;
      case "jul":
        return 7;
      case "aug":
        return 8;
      case "sep":
        return 9;
      case "oct":
        return 10;
      case "nov":
        return 11;
      case "dec":
        return 12;
      default:
        return 1;
    }
  }

  String _getMonthForReport(String _selectedMonth) {
    switch (_selectedMonth) {
      case "jan":
        return "January";
      case "feb":
        return "February";
      case "mar":
        return "March";
      case "apr":
        return "April";
      case "may":
        return "May";
      case "jun":
        return "June";
      case "jul":
        return "July";
      case "aug":
        return "August";
      case "sep":
        return "September";
      case "oct":
        return "October";
      case "nov":
        return "November";
      case "dec":
        return "December";
      default:
        return "January";
    }
  }
}
