import 'package:ecar_mobile/models/DriverVehicle/driverVehicle.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/driverVehicle_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/route_order_details_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
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

  List<DriverVehicle>? list = null;
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
    try {
      var filter = {"DatePickUp": DateTime.now().toIso8601String()};
      driverVehicles = await driverVehicleProvider.get(filter: filter);

      list =
          driverVehicles?.result.where((x) => x.dateDropOff == null).toList();

      setState(() {
        print("Number of driverVehicle items: ${driverVehicles?.count}");
        isLoading = false;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? getisLoadingHelper()
        : MasterScreen(
            "Order",
            SingleChildScrollView(
              child: Column(
                children: [
                  Align(alignment: Alignment.center, child: buildHeader("Choose your vehicle!")),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 530,
                    width: 400,
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
          );
  }

  List<Widget> _buildGridView() {
    if (list?.isEmpty ?? true) {
      return [
        Center(
            child: Text(
          "Sorry, there is no current available vehicles...",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ))
      ];
    }
    
    List<Widget> listWidget = list!.map((x) {
      return GestureDetector(
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
          height: 400,
          width: 400,
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 400,
                  width: 400,
                  child: x.vehicle?.image != null
                      ? StringHelpers.imageFromBase64String(
                          x.vehicle?.image!)
                      : Image.asset(
                          "assets/images/no_image_placeholder.png",
                          height: 300,
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.6],
                  ),
                ),
              ),
              
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    x.vehicle?.name ?? "",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              Positioned(
                bottom: 20,
                left: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16,
                      child: Icon(Icons.person, color: Colors.black87, size: 18),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "${x.driver?.user?.name ?? ""} ${x.driver?.user?.surname ?? ""}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              Positioned(
                bottom: 20,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Choose",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, color: Colors.amber, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
    
    return listWidget;
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
