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
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RentScreen()),
    );
  },
  icon: Icon(Icons.arrow_back, size: 30, color: Colors.black87),
  tooltip: "Back",
),

    Padding(
  padding: EdgeInsets.only(right: 50), 
  child: Center(child: Align(
            alignment: Alignment.center, 
            child: Text(
              "Recommended\n   vehicles...",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ))))
    ],
  ),
),
        if (recommendationList!.isEmpty)
         Padding(
          padding: const EdgeInsets.only(top: 150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.car_rental_outlined, size: 120, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No recommended vehicles available",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
        if (recommendationList!.isNotEmpty)
          Container(
            height: 800, 
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
        
      ],
    ));
  }

  List<Widget> _buildGridView(BuildContext context) {
    if (recommendationList!.isEmpty) {
      return [
        Center(
            child: Text(
          "Sorry, there is no current available vehicles...",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ))
      ];
    }
    
    List<Widget> list = recommendationList!.map((e) {
      return GestureDetector(
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
                  child: e.vehicle?.image != null
                      ? StringHelpers.imageFromBase64String(
                          e.vehicle?.image!)
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
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.recommend_sharp,
                    color: Colors.redAccent,
                    size: 30,
                    semanticLabel: "Recommended",
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
                    e.vehicle?.name ?? "",
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
                      backgroundColor: Colors.amber.withOpacity(0.9),
                      radius: 20,
                      child: Icon(Icons.attach_money, color: Colors.black87, size: 20),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price per day",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          "${e.vehicle?.price?.toStringAsFixed(2) ?? "0.00"} KM",
                          style: TextStyle(
                            fontSize: 18,
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
                        ),
                      ],
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
                        "Rent",
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
    
    return list;
  }

 
}
