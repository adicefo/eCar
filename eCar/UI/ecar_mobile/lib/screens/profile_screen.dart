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
import 'package:ecar_mobile/screens/profile_archive_screen.dart';
import 'package:ecar_mobile/screens/profile_edit_screen.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';

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

  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _telephoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  late AuthProvider authProvider;
  late UserProvider userProvider;
  late DriverProvider driverProvider;
  late StatisticsProvider statisticsProvider;

  late String _role;

  bool _fieldsEnabled = false;
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

    _nameController.text = "${user?.name}";
    _surnameController.text = "${user?.surname}";
    _telephoneNumberController.text = "${user?.telephoneNumber}";
    _emailController.text = "${user?.email}";

    if (_role == "driver") {
      _setStatisticsLogic();
    }
    setState(() {
      isLoading = false;
    });
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
        ? getisLoadingHelper()
        : MasterScreen(
            "Profile",
            SingleChildScrollView(
              child: _buildScreen(),
            ));
  }

  Widget _buildScreen() {
    return Column(
      children: [
        buildHeader("Profile"),
        SizedBox(
          height: 10,
        ),
        Icon(Icons.person, size: 50),
        SizedBox(height: 8),
        Text(
          user?.userName ?? "",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        _buildContent(),
        SizedBox(
          height: 40,
        ),
        _buildButtons(),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 300.0),
              child: Text(
                "Name: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              enabled: false,
              controller: _nameController,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(right: 300.0),
              child: Text(
                "Surname: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              enabled: false,
              controller: _surnameController,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(right: 210.0),
              child: Text(
                "Telephone number: ",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            TextField(
              enabled: false,
              controller: _telephoneNumberController,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(right: 300.0),
              child: Text(
                "Email: ",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            TextField(
              enabled: false,
              controller: _emailController,
              decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ));
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEditScreen(user: user),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(79, 255, 255, 255),
                  foregroundColor: Colors.black,
                  minimumSize: Size(150, 50)),
              child: Text(
                "Edit",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ),
        SizedBox(
          width: 50,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileArchiveScreen(
                      user: user,
                      role: _role,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(79, 255, 255, 255),
                  foregroundColor: Colors.black,
                  minimumSize: Size(150, 50)),
              child: Text(
                "Archive",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }
}
