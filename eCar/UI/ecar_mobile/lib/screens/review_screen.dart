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
    var filterReview = {"Page": 0, "PageSize": 6};
    data = await reviewProvider.get(filter: filterReview);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? getisLoadingHelper()
        : MasterScreen("Review", _buildScreen());
  }

  Widget _buildScreen() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            buildHeader("Reviews"),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 500,
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75),
                scrollDirection: Axis.vertical,
                children: _buildOrderGrid(),
              ),
            ),
            _buildButton(),
          ],
        ),
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
                color: Colors.white,
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
                            full: Icon(Icons.star, color: Colors.amber),
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
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.yellowAccent,
              borderRadius: BorderRadius.circular(16),
            ),
            width: MediaQuery.of(context).size.width * 0.75,
            height: 275,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                      "Description for\n ${object.reviewed?.user?.name} ${object?.reviewed?.user?.surname} from\n ${object.reviews?.user?.userName}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: Text(
                      object.description!,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: 1.1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Close")),
                )
              ],
            ),
          ),
        );
      },
    );
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
                  builder: (context) => ReviewDetailsScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(79, 255, 255, 255),
                foregroundColor: Colors.black,
                minimumSize: Size(300, 50)),
            child: Text(
              "Review",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
