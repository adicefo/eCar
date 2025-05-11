import 'package:ecar_mobile/models/Client/client.dart';
import 'package:ecar_mobile/models/Driver/driver.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/client_provider.dart';
import 'package:ecar_mobile/providers/driver_provider.dart';
import 'package:ecar_mobile/providers/review_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/review_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ReviewDetailsScreen extends StatefulWidget {
  const ReviewDetailsScreen({super.key});

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  User? user = null;

  Client? c = null;

  double? _rateValue = 1;
  Driver? _selectedDriver = null;

  TextEditingController _descriptionController = TextEditingController();
  SearchResult<Driver>? drivers;
  SearchResult<Client>? client;

  late UserProvider userProvider;
  late ClientProvider clientProvider;
  late DriverProvider driverProivder;
  late ReviewProvider reviewProvider;

  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    userProvider = context.read<UserProvider>();
    clientProvider = context.read<ClientProvider>();
    driverProivder = context.read<DriverProvider>();
    reviewProvider = context.read<ReviewProvider>();
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
try {
      user = await userProvider.getUserFromToken();

    var filterClient = {"NameGTE": user?.name, "SurnameGTE": user?.surname};
    client = await clientProvider.get(filter: filterClient);

    c = client?.result.first;

    drivers = await driverProivder.get();

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
        : MasterScreen("Review", _buildScreen());
  }

  Widget _buildScreen() {
    return SingleChildScrollView(
        child: Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 10),
              child: IconButton(onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewScreen(),
                  ),
                );
              }, icon: Icon(Icons.arrow_back,size: 30, color: Colors.black87)),
              ),
            Padding(padding: EdgeInsets.only(left: 10),
            child: buildHeader("Review your drive"),),
            ],
          ),
          _buildContent(), 
          _buildButton(),  
        ], 
      ),
    ));
  }

  Widget _buildContent() {
    return Wrap(
      children: [
        Row(
          children: [
            Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  "Value: ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
            RatingBar(
              minRating: 1,
              maxRating: 5,
              initialRating: 1,
              allowHalfRating: false,
              ratingWidget: RatingWidget(
                full: Icon(Icons.star, color: Colors.amber),
                half: Icon(Icons.star, color: Colors.grey),
                empty: Icon(Icons.star, color: Colors.grey),
              ),
              onRatingUpdate: (value) {
                _rateValue = value;
              },
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                "Driver: ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            DropdownMenu<Driver>(
              enableSearch: true,
              enableFilter: true,
              initialSelection: _selectedDriver,
              onSelected: (value) {
                _selectedDriver = value;
              },
              dropdownMenuEntries: drivers?.result
                      .map((x) => DropdownMenuEntry(
                          value: x,
                          label: "${x?.user?.name} ${x?.user?.surname}"))
                      .toList() ??
                  [],
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
                width: 375,
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 45.0),
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 9,
                    decoration: InputDecoration(
                      labelText: "Write here...",
                      fillColor: Colors.grey[200],
                      alignLabelWithHint: true,
                      filled: true,
                    ),
                  ),
                )),
          ],
        )
      ],
    );
  }

  Widget _buildButton() {
    return Center(
      child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              ElevatedButton.icon(
                  icon: Icon(Icons.save),
                  label: Text("Save"),
                  onPressed: () {
                    _sendReviewRequest();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      minimumSize: Size(250, 50)),)
                 
            ],
          )),
    );
  }

  void _sendReviewRequest() async {
    if (_selectedDriver == null ||
        _descriptionController.text.trim().isEmpty == "") {
      AlertHelpers.showAlert(context, "Error", "Please enter required fields");
      return;
    }
    bool? confirmEdit = await AlertHelpers.reviewSaveConfirmation(context,
        text:
            "Do you want to review ${_selectedDriver?.user?.name} ${_selectedDriver?.user?.surname}?");
    if (confirmEdit == true) {
      var request = {
        "value": _rateValue!.toInt(),
        "description": _descriptionController.text.toString(),
        "reviewsId": c?.id,
        "reviewedId": _selectedDriver?.id,
      };
      try {
        await reviewProvider.insert(request);
        ScaffoldHelpers.showScaffold(context, "Your drive has been reviewed");
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewScreen(),
          ),
        );
      } catch (e) {
        ScaffoldHelpers.showScaffold(context, e.toString());
      }
    }
  }
}
