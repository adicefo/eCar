import 'package:ecar_mobile/models/Driver/driver.dart';
import 'package:ecar_mobile/models/Statistics/statistics.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/models/Notification/notification.dart' as Model;
import 'package:ecar_mobile/providers/driver_provider.dart';
import 'package:ecar_mobile/providers/notification_provider.dart';
import 'package:ecar_mobile/providers/statistics_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:ecar_mobile/utils/string_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  bool? isFromLogin;
  NotificationScreen(this.isFromLogin, {super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? user = null;
  Statistics? statistics = null;

  SearchResult<Model.Notification>? data = null;
  SearchResult<Driver>? driver = null;

  final _storage = FlutterSecureStorage();
  late UserProvider userProvider;
  late NotificationProvider notificationProvider;
  late DriverProvider driverProvider;
  late StatisticsProvider statisticsProvider;

  String? _role;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    userProvider = context.read<UserProvider>();
    notificationProvider = context.read<NotificationProvider>();
    driverProvider = context.read<DriverProvider>();
    statisticsProvider = context.read<StatisticsProvider>();
    super.initState();
    _initForm();
  }

  Future _initForm() async {
    user = await userProvider.getUserFromToken();
    _role = await _storage.read(key: "role") ?? "";

    bool isForClient = false;

    if (_role == "client") {
      isForClient = true;
    }

    var filter = {'IsForClient': isForClient};
    data = await notificationProvider.get(filter: filter);

    setState(() {
      if (_role == "driver") {
        _setDriverStatisticsLogic();
      }
      isLoading = false;
      print("Result count : ${data!.count}");
    });
  }

  Future _setDriverStatisticsLogic() async {
    var filter = {"NameGTE": user?.name, "SurnameGTE": user?.surname};
    driver = await driverProvider.get(filter: filter);
    //taking only one from SearchResult
    var d = driver?.result.first;

    if (widget.isFromLogin == true) {
      var request = {"driverId": d?.id};
      //user is logged in
      statistics = await statisticsProvider.insert(request);
      ScaffoldHelpers.showScaffold(context, "Working day started");
    } else {
      var filter = {
        "DriverId": d?.id,
        "BeginningOfWork": DateTime.now().toIso8601String()
      };
      var s = await statisticsProvider.get(filter: filter);
      //taking only one from SearchResult
      var stat = s?.result.first;

      //update every time acessing page
      var request = {};
      statistics = await statisticsProvider.update(stat?.id, request);
    }
    setState(() {
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
            "Home",
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    _buildHeader(),
                    Container(
                      height: 500,
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3 / 1),
                        scrollDirection: Axis.vertical,
                        children: _buildGridView(),
                      ),
                    ),
                    _buildStatistics(),
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
                "Welcome!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              )),
          SizedBox(
            height: 0,
          ),
          Align(
              alignment: Alignment.center,
              child: Text(
                "${user?.userName}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  List<Widget> _buildGridView() {
    if (data?.result?.length == 0) {
      return [Text("Sorry there is no current available notifications...")];
    }
    List<Widget> list = data!.result
        .map(
          (x) => GestureDetector(
              onTap: () {
                _showCustomModal(x);
              },
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, strokeAlign: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: x.image == null
                          ? Container(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                "assets/images/no_image_placeholder.png",
                                height: 100,
                                width: 100,
                              ),
                            )
                          : StringHelpers.imageFromBase64String(x.image!),
                    ),
                    Text(
                      x.heading ?? "",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
        )
        .cast<Widget>()
        .toList();
    return list;
  }

  void _showCustomModal(Model.Notification object) {
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
                Text(object.heading!,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        border:
                            Border.all(color: Colors.black, strokeAlign: 1)),
                    child: Text("Notification details :",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: Text(
                      object.content_!,
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

  Widget _buildStatistics() {
    if (_role == "client" || _role == "") {
      return SizedBox.shrink();
    }
    return Container(
        height: 85,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.yellowAccent,
          border: Border.all(color: Colors.black, strokeAlign: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.watch_later_outlined),
                  Text(
                    statistics!.numberOfHours!.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Total hours",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                children: [
                  Icon(Icons.attach_money),
                  Text(statistics!.priceAmount!.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Total amount",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                children: [
                  Icon(Icons.directions_walk_rounded),
                  Text(statistics!.numberOfClients!.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Total clients",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        ));
  }
}
