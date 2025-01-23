import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/models/Notification/notification.dart' as Model;
import 'package:ecar_mobile/providers/notification_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/string_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User? user = null;

  SearchResult<Model.Notification>? data = null;

  final _storage = FlutterSecureStorage();
  late UserProvider userProvider;
  late NotificationProvider notificationProvider;

  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    userProvider = context.read<UserProvider>();
    notificationProvider = context.read<NotificationProvider>();
    _initForm();
  }

  Future _initForm() async {
    user = await userProvider.getUserFromToken();
    var role = await _storage.read(key: "role") ?? "";
    bool isForClient = false;
    if (role == "client") {
      isForClient = true;
    }
    var filter = {'IsForClient': isForClient};
    data = await notificationProvider.get(filter: filter);
    setState(() {
      isLoading = false;
      print("Result count : ${data!.count}");
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
                    )
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
                "Dobrodošli!",
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
      return [Text("Loading...")];
    }
    List<Widget> list = data!.result
        .map(
          (x) => GestureDetector(
              onTap: () {
                AlertHelpers.showAlert(context, "Bravo!",
                    "You have just clicked: ${x.id.toString() ?? "0"} notification");
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
                          ? Placeholder()
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
}
