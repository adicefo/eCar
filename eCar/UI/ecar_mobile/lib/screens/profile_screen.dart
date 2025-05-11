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
  TextEditingController _genderController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
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
    try {
      user = await userProvider.getUserFromToken();
      _role = await _storage.read(key: "role") ?? "";

      _nameController.text = "${user?.name}";
      _surnameController.text = "${user?.surname}";
      _telephoneNumberController.text = "${user?.telephoneNumber}";
      _emailController.text = "${user?.email}";
      _genderController.text="${user?.gender}";
      _userNameController.text="${user?.userName}";
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
            "Profile",
            SingleChildScrollView(
              child: _buildScreen(),
            ));
  }

  Widget _buildScreen() {
    return Column(
      children: [
        buildHeader("Profile"),
        SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.amber.shade100,
          child: Icon(Icons.person, size: 60, color: Colors.amber.shade800),
        ),
        SizedBox(height: 16),
        Text(
          user?.userName ?? "",
          style: TextStyle(
            fontSize: 26, 
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 6),
        Text(
          user?.email ?? "",
          style: TextStyle(
            fontSize: 16, 
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        _buildContent(),
        SizedBox(height: 30),
        _buildButtons(),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.shade200, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber.shade800),
                    SizedBox(width: 10),
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildProfileField(
                    icon: Icons.person,
                    label: "Name",
                    controller: _nameController,
                  ),
                  SizedBox(height: 16),
                  
                  _buildProfileField(
                    icon: Icons.person_outline,
                    label: "Surname",
                    controller: _surnameController,
                  ),
                  SizedBox(height: 16),
                  
                  _buildProfileField(
                    icon: Icons.account_circle,
                    label: "Username",
                    controller: _userNameController,
                  ),
                  SizedBox(height: 16),
                  
                  _buildProfileField(
                    icon: Icons.email,
                    label: "Email",
                    controller: _emailController,
                  ),
                  SizedBox(height: 16),
                  
                  _buildProfileField(
                    icon: Icons.people,
                    label: "Gender",
                    controller: _genderController,
                  ),
                  SizedBox(height: 16),
                  
                  _buildProfileField(
                    icon: Icons.phone,
                    label: "Phone Number",
                    controller: _telephoneNumberController, 
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build consistent profile fields
  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.amber.shade700),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
          TextField(
          enabled: false,
          controller: controller,
          decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 249, 231),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
  
  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEditScreen(user: user),
                  ),
                );
              },
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[600],
                shadowColor: Colors.black,
                surfaceTintColor: Colors.blueAccent,
                elevation: 3,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(0, 50),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: FilledButton.icon(
              onPressed: () async {
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
              icon: Icon(Icons.archive),
              label: Text("View Archive"),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black87,
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[600],
                shadowColor: Colors.black,
                surfaceTintColor: Colors.amber,
                elevation: 3,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(0, 50),
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
