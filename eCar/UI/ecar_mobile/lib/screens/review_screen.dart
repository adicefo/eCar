import 'dart:math';

import 'package:ecar_mobile/models/Client/client.dart';
import 'package:ecar_mobile/models/Driver/driver.dart';
import 'package:ecar_mobile/models/Review/review.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/client_provider.dart';
import 'package:ecar_mobile/providers/driver_provider.dart';
import 'package:ecar_mobile/providers/review_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/review_details_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  User? user = null;

  Client? c = null;

  SearchResult<Client>? client;
  SearchResult<Review>? data;
  SearchResult<Driver>? drivers;

  late ReviewProvider reviewProvider;

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState

    reviewProvider = context.read<ReviewProvider>();
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    try {
      var filterReview = {"Page": 0, "PageSize": 4};
      data = await reviewProvider.get(filter: filterReview);

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
        : MasterScreen("Review", _buildScreen(),floatingActionButton: FloatingActionButton.extended(
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewDetailsScreen(),
      ),
    );
  },
  label: Text('Write a Review'),
    tooltip: 'Tap to write your own review',

  icon: Icon(Icons.rate_review),
  backgroundColor: Colors.blueAccent,
  foregroundColor: Colors.white,
 
),
);
  }

  Widget _buildScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildHeader("Reviews"),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 500,
            child: GridView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.6,
    ),
    scrollDirection: Axis.vertical,
    children: _buildOrderGrid(),
  ),
),
SizedBox(height: 10,),
Center(
      child: Text(
        'Want to share your experience? Tap below!',
        style: TextStyle(fontSize: 16, color: Colors.blueGrey,decoration: TextDecoration.underline),
      ),
    ),

        ],
      ),
    );
  }

  List<Widget> _buildOrderGrid() {
    if (data?.result?.length == 0) {
      return [SizedBox.shrink()];
    }
    return data!.result
        .map((x) {
          return GestureDetector(
            onTap: () {
              _showCustomModal(x);
            },
            child: Container(
              height: 500,
              width: 500,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        Icon(Icons.person, size: 40),
                        SizedBox(height: 8),
                        Text(
                          x.reviews?.user?.userName ?? "",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Reviewed: ${x?.reviewed?.user?.name ?? ""} ${x?.reviewed?.user?.surname ?? ""}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        RatingBar(
                          minRating: 1,
                          maxRating: 5,
                          initialRating:
                              double.tryParse(x.value!.toString()) ?? 0.0,
                          allowHalfRating: false,
                          ratingWidget: RatingWidget(
                            full: Icon(Icons.star, color: Colors.blueAccent),
                            half: Icon(Icons.star, color: Colors.grey),
                            empty: Icon(Icons.star, color: Colors.grey),
                          ),
                          onRatingUpdate: (value) {
                            print(value);
                          },
                          ignoreGestures: true,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                      onTap: () {
                        _showCustomModal(x);
                      },
                      child: Text(
                        "Description",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        })
        .cast<Widget>()
        .toList();
  }

  void _showCustomModal(Review object) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Review Details',
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuint,
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        final DateTime reviewDate = object.addedDate ?? DateTime.now();
        final String formattedDate = "${reviewDate.day} ${_getMonthName(reviewDate.month)} ${reviewDate.year}";
        
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber.shade300, Colors.amber.shade500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 8,
                            top: 0,
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.black87),
                              onPressed: () => Navigator.pop(context),
                              splashRadius: 20,
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "Review",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${object.reviewed?.user?.name ?? ""} ${object.reviewed?.user?.surname ?? ""}",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  radius: 24,
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.amber.shade700,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${object.reviews?.user?.userName ?? ""}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          formattedDate,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: double.tryParse(object.value?.toString() ?? '0') ?? 0,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 24.0,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "${double.tryParse(object.value?.toString() ?? '0')?.toStringAsFixed(1) ?? '0.0'}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            Divider(thickness: 1),
                            
                            Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 4),
                              child: Text(
                                "Review",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                object.description ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black87,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text("Close"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  String _getMonthName(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }

  
}
