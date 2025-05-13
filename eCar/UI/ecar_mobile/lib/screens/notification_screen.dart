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
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
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
    try {
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
        print("Result count : ${data?.count}");
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
    }
  }

  Future _setDriverStatisticsLogic() async {
    try {
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
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? getisLoadingHelper()
        : MasterScreen(
            "Home",
            SingleChildScrollView(
              child: Column(
                children: [
                  buildHeader("Welcome!"),
                  buildHeader("${user?.userName}"),
                  SizedBox(height: 10),
                  Padding(padding: EdgeInsets.all(8.0),
                  child:Container(
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200, width: 2),
                    ),
                    constraints: BoxConstraints(
                      maxWidth:300,
                      maxHeight: 200,
                    ),
                    child: Text("There are some notifications for you! Feel free to check them out!",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                  ),),
                  SizedBox(height: 10,),
                  Container(
                    height: _role=="driver"?400:600,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2.8),
                      scrollDirection: Axis.vertical,
                      children: _buildGridView(),
                    ),
                  ),
                  SizedBox(height: 20,),
                  _buildStatistics(),
                ],
              ),
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
              child: Padding(
                padding: const EdgeInsets.only(left:8.0,right: 8.0,top:8.0),
                child: Container(
                height: _role=="driver"?400:600,
                width: 400,
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
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
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
      barrierDismissible: true,
      barrierLabel: 'Notification Details',
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
        final DateTime notificationDate = object.addingDate ?? DateTime.now();
        final String formattedDate = "${notificationDate.day} ${_getMonthName(notificationDate.month)} ${notificationDate.year}";
        
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
                          colors: [
                            _role == "driver" ? Colors.blueAccent : Colors.amber.shade300, 
                            _role == "driver" ? Colors.blueAccent : Colors.amber.shade500
                          ],
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
                                  "Notification",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
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
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: _role == "driver" ? Colors.blue.shade100 : Colors.amber.shade100,
                                        radius: 24,
                                        child: Icon(
                                          Icons.notifications,
                                          size: 30,
                                          color: _role == "driver" ? Colors.blue.shade700 : Colors.amber.shade700,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          object.heading ?? "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: 16),
                            
                            Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 8),
                              child: Text(
                                "Message",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                object.content_ ?? "",
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
                              backgroundColor: _role == "driver" ? Colors.blue : Colors.amber,
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
                    statistics?.numberOfHours?.toString() ?? "0",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Total hours",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                children: [
                  Icon(Icons.attach_money),
                  Text(statistics?.priceAmount?.toString() ?? "0",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Total amount",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
              Column(
                children: [
                  Icon(Icons.directions_walk_rounded),
                  Text(statistics?.numberOfClients?.toString() ?? "0",
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
