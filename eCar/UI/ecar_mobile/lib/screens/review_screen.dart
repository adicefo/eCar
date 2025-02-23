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
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helper.dart';
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

  late UserProvider userProvider;
  late ClientProvider clientProvider;
  late ReviewProvider reviewProvider;
  late DriverProvider driverProivder;

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    userProvider = context.read<UserProvider>();
    clientProvider = context.read<ClientProvider>();
    reviewProvider = context.read<ReviewProvider>();
    driverProivder = context.read<DriverProvider>();
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    user = await userProvider.getUserFromToken();

    var filterClient = {"NameGTE": user?.name, "SurnameGTE": user?.surname};
    client = await clientProvider.get(filter: filterClient);

    c = client?.result.first;

    drivers = await driverProivder.get();
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
            _buildHeader(),
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
          ],
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
                "Reviews",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  List<Widget> _buildOrderGrid() {
    if (data?.result?.length == 0) {
      return [SizedBox.shrink()];
    }
    List<Widget> list = data!.result
        .map((x) => GestureDetector(
              onTap: () {
                _showCustomModal(x);
              },
              child: Container(
                height: 500,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, strokeAlign: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      weight: 50,
                    ),
                    Text(
                      x.reviews?.user?.userName ?? "",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Reviewed: ${x?.reviewed?.user?.name} ${x?.reviewed?.user?.surname}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    RatingBar(
                      minRating: 1,
                      maxRating: 5,
                      initialRating:
                          double.tryParse(x.value!.toString()) ?? 0.0,
                      allowHalfRating: false,
                      ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          half: Icon(
                            Icons.star,
                            color: Colors.grey,
                          ),
                          empty: Icon(
                            Icons.star,
                            color: Colors.grey,
                          )),
                      onRatingUpdate: (value) {
                        print(value);
                      },
                      ignoreGestures: true,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      child: Text("Click for description",
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ),
            ))
        .cast<Widget>()
        .toList();
    return list;
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
            height: 500,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
}
