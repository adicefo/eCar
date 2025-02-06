import 'package:ecar_mobile/models/DriverVehicle/driverVehicle.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/driverVehicle_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/route_order_details_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/string_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteOrderScreen extends StatefulWidget {
  const RouteOrderScreen({super.key});

  @override
  State<RouteOrderScreen> createState() => _RouteOrderScreenState();
}

class _RouteOrderScreenState extends State<RouteOrderScreen> {
  late DriverVehicleProvider driverVehicleProvider;

  SearchResult<DriverVehicle>? driverVehicles = null;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    driverVehicleProvider = context.read<DriverVehicleProvider>();
    super.initState();
    _initForm();
  }

  Future _initForm() async {
    var filter = {"DatePickUp": DateTime.now().toIso8601String()};
    driverVehicles = await driverVehicleProvider.get(filter: filter);

    setState(() {
      print("Number of driverVehicle items: ${driverVehicles?.count}");
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Go back"),
            ),
          )
        : MasterScreen(
            "Order",
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    _buildHeader(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 350,
                      width: 350,
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3 / 1),
                        scrollDirection: Axis.vertical,
                        children: _buildGridView(),
                      ),
                    ),
                    _buildButton()
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Align(
              alignment: Alignment.center,
              child: Text(
                "Choose your\n    vehicle!",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  List<Widget> _buildGridView() {
    if (driverVehicles?.result.length == 0) {
      return [
        Center(
            child: Text(
          "Sorry, there is no current available vehicles...",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ))
      ];
    }
    List<Widget> list = driverVehicles!.result
        .map((x) => GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteOrderDetailsScreen(
                      true,
                      object: x,
                    ),
                  ),
                );
              },
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, strokeAlign: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                        child: Container(
                      height: 350,
                      width: 350,
                      child: x.vehicle?.image != null
                          ? StringHelpers.imageFromBase64String(
                              x.vehicle?.image!)
                          : Image.asset(
                              "assets/images/no_image_placeholder.png",
                              height: 300,
                              width: 300,
                              fit: BoxFit.cover,
                            ),
                    )),
                    Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          x.vehicle?.name ?? "",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellowAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
        .cast<Widget>()
        .toList();
    return list;
  }

  Widget _buildButton() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteOrderDetailsScreen(false),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(79, 255, 255, 255),
                foregroundColor: Colors.black,
                minimumSize: Size(300, 50)),
            child: Text(
              "My orders",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
