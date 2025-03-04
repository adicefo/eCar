import 'package:ecar_mobile/models/Rent/rent.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/rent_details_screen.dart';
import 'package:ecar_mobile/screens/rent_screen.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/string_helpers.dart';
import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  List<Rent>? recommendationList;
  RecommendationScreen({required this.recommendationList});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Rent",
      _buildScreen(context),
    );
  }

  Widget _buildScreen(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 50),
            child: buildHeader("Recommended     vehicels...")),
        if (recommendationList!.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, strokeAlign: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Sorry, there is no recommended vehicles\n based on previous car.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        if (recommendationList!.isNotEmpty)
          Container(
            height: 450,
            width: 400,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3 / 1),
              scrollDirection: Axis.vertical,
              children: _buildGridView(context),
            ),
          ),
        if (recommendationList!.isEmpty)
          SizedBox(
            height: 350,
          ),
        _buildBtnBack(context),
      ],
    ));
  }

  List<Widget> _buildGridView(BuildContext context) {
    List<Widget> list = recommendationList!
        .map((e) => GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RentDetailsScreen(
                      true,
                      object: e.vehicle,
                    ),
                  ),
                );
              },
              child: Container(
                height: 400,
                width: 400,
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
                      child: e?.vehicle?.image != null
                          ? StringHelpers.imageFromBase64String(
                              e?.vehicle?.image!)
                          : Image.asset(
                              "assets/images/no_image_placeholder.png",
                              height: 300,
                              width: 300,
                              fit: BoxFit.cover,
                            ),
                    )),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(
                        semanticLabel: "Recommended",
                        Icons.recommend_sharp,
                        color: Colors.redAccent,
                        size: 50,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          e?.vehicle?.name ?? "",
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

  Widget _buildBtnBack(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RentScreen(),
          ),
        );
      },
      child: Text("Go back"),
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(76, 255, 255, 255),
          foregroundColor: Colors.black,
          minimumSize: Size(200, 50)),
    );
  }
}
