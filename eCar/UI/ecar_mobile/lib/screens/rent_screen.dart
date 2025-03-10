import 'package:ecar_mobile/models/Client/client.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/Vehicle/vehicle.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/client_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/providers/vehicle_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/rent_details_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:ecar_mobile/utils/string_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  User? user = null;

  SearchResult<Client>? client;
  SearchResult<Vehicle>? data;

  Client? c;

  late VehicleProvider vehicleProvider;

  bool isLoading = true;

  @override
  void initState() {
    vehicleProvider = context.read<VehicleProvider>();
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    try {
      data = await vehicleProvider.get();

      setState(() {
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
            "Rent",
            SingleChildScrollView(
              child: Column(
                children: [
                  buildHeader("Choose your\n    vehicle!"),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 450,
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
    if (data?.result.length == 0) {
      return [
        Center(
            child: Text(
          "Sorry, there is no current available vehicles...",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ))
      ];
    }
    List<Widget> list = data!.result
        .map((x) => GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RentDetailsScreen(
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
                      height: 400,
                      width: 400,
                      child: x.image != null
                          ? StringHelpers.imageFromBase64String(x.image!)
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
                          x.name ?? "",
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
                  builder: (context) => RentDetailsScreen(false),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(79, 255, 255, 255),
                foregroundColor: Colors.black,
                minimumSize: Size(300, 50)),
            child: Text(
              "My rents",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
