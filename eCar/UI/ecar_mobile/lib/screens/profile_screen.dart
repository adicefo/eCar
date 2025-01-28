import 'package:ecar_mobile/main.dart';
import 'package:ecar_mobile/models/Driver/driver.dart';
import 'package:ecar_mobile/models/Statistics/statistics.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/auth_provider.dart';
import 'package:ecar_mobile/providers/driver_provider.dart';
import 'package:ecar_mobile/providers/statistics_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = null;
  Statistics? statistics = null;
  SearchResult<Driver>? driver = null;

  final _storage = FlutterSecureStorage();

  late AuthProvider authProvider;
  late UserProvider userProvider;
  late DriverProvider driverProvider;
  late StatisticsProvider statisticsProvider;

  late String _role;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    authProvider = context.read<AuthProvider>();
    userProvider = context.read<UserProvider>();
    driverProvider = context.read<DriverProvider>();
    statisticsProvider = context.read<StatisticsProvider>();
    super.initState();
    _initForm();
  }

  Future _initForm() async {
    user = await userProvider.getUserFromToken();
    _role = await _storage.read(key: "role") ?? "";
    if (_role == "driver") {
      _setStatisticsLogic();
    }
  }

  Future _setStatisticsLogic() async {
    var filter = {"NameGTE": user?.name, "SurnameGTE": user?.surname};
    driver = await driverProvider.get(filter: filter);

    var d = driver?.result.first;

    var filterStat = {
      "DriverId": d?.id,
      "BeginningOfWork": DateTime.now().toIso8601String()
    };
    var stat = await statisticsProvider.get(filter: filterStat);

    statistics = stat?.result.first;
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
            "Profile",
            SingleChildScrollView(
              child: Container(
                height: 300,
                width: 300,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_role == "driver") {
                        statistics = await statisticsProvider
                            .updateFinish(statistics?.id);
                      }
                      authProvider.logout(context);
                    },
                    child: Text("Logout")),
              ),
            ));
  }
}
