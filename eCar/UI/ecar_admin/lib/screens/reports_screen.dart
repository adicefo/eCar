import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/Rent/rent.dart';
import 'package:ecar_admin/models/Review/review.dart';
import 'package:ecar_admin/models/Route/route.dart' as Model;
import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/client_provider.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/rent_provider.dart';
import 'package:ecar_admin/providers/review_provider.dart';
import 'package:ecar_admin/providers/route_provider.dart';
import 'package:ecar_admin/providers/vehicle_provider.dart';
import 'package:ecar_admin/screens/drivers_screen.dart';
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

  bool _drawForDriverFirstTime = false;
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
  SearchResult<Rent>? rents;
  SearchResult<Vehicle>? vehicles;
  late DriverProvider driverProvider;
  late ClientProvider clientProvider;
  late RouteProvider routeProvider;
  late ReviewProvider reviewProvider;
  late RentProvider rentProvider;
  late VehicleProvider vehicleProvider;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    driverProvider = context.read<DriverProvider>();
    clientProvider = context.read<ClientProvider>();
    routeProvider = context.read<RouteProvider>();
    reviewProvider = context.read<ReviewProvider>();
    rentProvider = context.read<RentProvider>();
    vehicleProvider = context.read<VehicleProvider>();

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
    try {
      drivers = await driverProvider.get();
      clients = await clientProvider.get();
      routes = await routeProvider.get();
      reviews = await reviewProvider.get();
      rents = await rentProvider.get();
      vehicles = await vehicleProvider.get();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  Future<Map<int, double>> fetchYearlyData(int year) async {
    try {
      Map<int, double> data = {};
      for (int month = 1; month <= 12; month++) {
        var filter = {"Month": month, "Year": year};
        double amount = await routeProvider.getForReport(filter);
        data[month] = amount;
        year == 2024 ? _total2024 += amount : _total2025 += amount;
      }
      return data;
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
    return {};
  }

  //help function for pie chart
  Map<String, int> _countVehiclesInRents(SearchResult<Rent>? rents) {
    final Map<String, int> counts = {};

    for (var rent in rents!.result) {
      final vehicleName = rent.vehicle?.name ?? "";
      counts[vehicleName] = (counts[vehicleName] ?? 0) + 1;
    }

    return counts;
  }

//help function for pie chart
  List<PieChartSectionData> _buildVehiclePieSections(Map<String, int> counts) {
    final total = counts.values.fold(0, (sum, value) => sum + value);

    return counts.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        title: "${entry.key}\n${percentage.toStringAsFixed(1)}%",
        value: entry.value.toDouble(),
        color: _getRandomColor(entry.key),
        radius: 100,
        titleStyle: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

//help function for pie chart
  Color _getRandomColor(String key) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple
    ];
    return colors[key.hashCode % colors.length];
  }

  Future<void> _exportToCSV() async {
    try {
      // Prepare CSV rows (headers + data)
      List<List<dynamic>> rows = [];

      // Add headers
      rows.add([
        "Driver ID",
        "Driver Name",
        "Driver Surname",
        "Driver Email",
        "Driver Gender",
        "Driver Username",
        "Driver Telephone Number"
      ]);

      for (var driver in drivers!.result) {
        rows.add([
          driver.id,
          "${driver.user?.name}",
          "${driver.user?.surname}",
          driver.user?.email ?? "",
          driver.user?.gender ?? "",
          driver.user?.userName ?? "",
          driver.user?.telephoneNumber ?? "",
        ]);
      }
      rows.add([
            "Vehicle ID",
        "Vehicle Name",
        "Vehicle Price",
        "Vehicle Consumption",
        "Vehicle Availability"
      ]);

      for (var vehicle in vehicles!.result) {
        rows.add([
          vehicle.id,
          vehicle.name,
          vehicle.price,
          vehicle.averageConsumption,
          vehicle.available
        ]);
      }

      // Convert rows to CSV string
      String csvData = const ListToCsvConverter().convert(rows);

      // Ask user where to save file
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: "Save report as CSV",
        fileName: "drivers_and_vehicles.csv",
        type: FileType.custom,
        allowedExtensions: ["csv"],
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(csvData);
        ScaffoldHelpers.showScaffold(context, "Export successful: $outputFile");
      }
    } catch (e) {
      ScaffoldHelpers.showScaffold(
          context, "Error exporting CSV: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Reports",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 150),
            child: ElevatedButton.icon(
              onPressed: _exportToCSV,
              icon: Icon(Icons.file_download),
              label: Text("Export to CSV"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 28, 128, 31),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(150, 50),
                padding: EdgeInsets.symmetric(horizontal: 32),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.yellowAccent,
        leading: IconButton(
          tooltip: "Go back",
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DriversListScreen(),
              ),
            );
          },
        ),
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
    List<String> menuItems = ["Drivers", "Routes", "Reviews", "Vehicles"];

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
      case 3:
        return _buildVehiclesContent();
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
          width: !_drawForDriverFirstTime ? 250 : 450,
          child: DropdownButtonFormField<String>(
            isDense: true,
            focusColor: const Color.fromARGB(255, 255, 255, 255),
            decoration: InputDecoration(
                labelText: "Filter by",
                labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                filled: true,
                fillColor: Colors.white),
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
        if (!_drawForDriverFirstTime)
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _drawForDriver = true;
                _drawForDriverFirstTime = true;
              });
            },
            icon: Icon(Icons.filter_list),
            label: Text("Apply Filter",
                style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
                foregroundColor: Colors.black,
                minimumSize: Size(150, 50),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
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
            aspectRatio: 4.5,
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
            decoration: InputDecoration(
                labelText: "Month",
                labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                filled: true,
                fillColor: Colors.white),
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
            decoration: InputDecoration(
                labelText: "Year",
                labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                filled: true,
                fillColor: Colors.white),
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
        ElevatedButton.icon(
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
          icon: Icon(Icons.filter_list),
          label: Text("Apply Filter",
              style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(150, 50),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
        )
      ],
    );
  }

  Widget _buildTableBtnRoute() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _drawForRoute ? Colors.orange : Colors.blue.shade600,
            foregroundColor: Colors.white,
            minimumSize: Size(200, 50),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: Icon(_drawForRoute ? Icons.visibility_off : Icons.table_chart),
          onPressed: () => {
                setState(() {
                  _drawForRoute = !_drawForRoute;
                })
              },
          label: Text(_drawForRoute ? "Hide data table" : "Show data table",
              style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }

  Widget _buildTableRoute() {
    Map<int, double> data = _selectedYearRoute == "2025" ? data2025 : data2024;
    double total = _selectedYearRoute == "2025" ? _total2025 : _total2024;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Yearly Distance Data (KM)",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              DataTable(
                columnSpacing: 10,
                headingRowColor:
                    MaterialStateProperty.all(Colors.grey.shade200),
                dataRowColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.grey.withOpacity(0.2);
                    }
                    return Colors.transparent;
                  },
                ),
                border: TableBorder.all(
                  color: Colors.grey.shade300,
                  width: 1,
                  borderRadius: BorderRadius.circular(8),
                ),
                columns: [
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Year",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                      label: Text("January",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("February",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("March",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("April",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("May",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("June",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("July",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("August",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("September",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("October",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("November",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("December",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Total",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        Container(
                          color: Colors.blue.withOpacity(0.1),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            "2024",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ),
                      ...List.generate(
                        12,
                        (index) => DataCell(
                          Text(
                              "${data2024[index + 1]?.toStringAsFixed(2) ?? '0'} KM"),
                        ),
                      ),
                      DataCell(
                        Container(
                          color: Colors.blue.withOpacity(0.1),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            "${_total2024.toStringAsFixed(2)} KM",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Container(
                          color: Colors.green.withOpacity(0.1),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            "2025",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ),
                      ...List.generate(
                        12,
                        (index) => DataCell(
                          Text(
                              "${data2025[index + 1]?.toStringAsFixed(2) ?? '0'} KM"),
                        ),
                      ),
                      DataCell(
                        Container(
                          color: Colors.green.withOpacity(0.1),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            "${_total2025.toStringAsFixed(2)} KM",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
            decoration: InputDecoration(
                labelText: "Month",
                labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                filled: true,
                fillColor: Colors.white),
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
            decoration: InputDecoration(
                labelText: "Year",
                labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                filled: true,
                fillColor: Colors.white),
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
        ElevatedButton.icon(
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
          icon: Icon(Icons.filter_list),
          label: Text("Apply Filter",
              style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(150, 50),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
        )
      ],
    );
  }

  Widget _buildVehiclesContent() {
    final vehicleCounts = _countVehiclesInRents(rents);
    final sections = _buildVehiclePieSections(vehicleCounts);

    return RepaintBoundary(
      key: chartKey,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Number of vehicles rented",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 65,
          ),
          AspectRatio(
            aspectRatio: 4.5,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 4,
                centerSpaceRadius: 80,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          _drawExportPdfBtn("vehicle")
        ],
      ),
    );
  }

  Widget _buildContainer(String hint, int? number) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ]),
      height: 50,
      width: 450,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: number != null
            ? Text("$hint $number",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87))
            : Text("$hint",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87)),
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
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            minimumSize: Size(220, 50),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: Icon(Icons.picture_as_pdf),
          onPressed: () => _exportToPdf(entity),
          label: Text("Export to PDF",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
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
            ],
            if (entity == "vehicle") ...[
              pw.Text('Percentage of vehicle rentage'),
              pw.SizedBox(height: 10),
              if (imageBytes != null)
                pw.Image(pw.MemoryImage(imageBytes), height: 200)
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
      allowedExtensions: ['.pdf'],
      fileName: entity == "driver"
          ? "ecar_report_driver.pdf"
          : entity == "route"
              ? "ecar_report_route.pdf"
              : entity == "review"
                  ? "ecar_report_review.pdf"
                  : "ecar_report_vehicle.pdf",
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
