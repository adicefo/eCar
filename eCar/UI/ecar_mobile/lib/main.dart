import 'package:ecar_mobile/providers/auth_provider.dart';
import 'package:ecar_mobile/providers/client_provider.dart';
import 'package:ecar_mobile/providers/driverVehicle_provider.dart';
import 'package:ecar_mobile/providers/driver_provider.dart';
import 'package:ecar_mobile/providers/notification_provider.dart';
import 'package:ecar_mobile/providers/rent_provider.dart';
import 'package:ecar_mobile/providers/request_provider.dart';
import 'package:ecar_mobile/providers/review_provider.dart';
import 'package:ecar_mobile/providers/route_provider.dart';
import 'package:ecar_mobile/providers/statistics_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/providers/vehicle_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/notification_screen.dart';
import 'package:ecar_mobile/screens/register_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/authorization.dart';
import 'package:flutter_stripe/flutter_stripe.dart'
    as stripe; //because it is naming conflict with flutter/material.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  String? mapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  if (mapsApiKey == null || mapsApiKey.isEmpty) {
    print("❌ GOOGLE_MAPS_API_KEY is missing in .env file!");
  } else {
    print("✅ GOOGLE_MAPS_API_KEY Loaded:");
  }
  String? stripeKey = dotenv.env['STRIPE_PUBLISH_KEY'];
  if (stripeKey == null || stripeKey.isEmpty) {
    print("❌ Stripe key is missing in .env file!");
  } else {
    stripe.Stripe.publishableKey = stripeKey;
    await stripe.Stripe.instance.applySettings();
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider("Users/client_login")),
    ChangeNotifierProvider(create: (_) => ClientProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ChangeNotifierProvider(create: (_) => DriverProvider()),
    ChangeNotifierProvider(create: (_) => StatisticsProvider()),
    ChangeNotifierProvider(create: (_) => VehicleProvider()),
    ChangeNotifierProvider(create: (_) => DriverVehicleProvider()),
    ChangeNotifierProvider(create: (_) => RouteProvider()),
    ChangeNotifierProvider(create: (_) => RequestProvider()),
    ChangeNotifierProvider(create: (_) => RentProvider()),
    ChangeNotifierProvider(create: (_) => ReviewProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eCar Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
        useMaterial3: true,
       
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  AuthProvider? _authProvide;
  String _userType = "client";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "@eCar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              "Login page",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.yellowAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 400, maxHeight: 500),
                child: Card(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/55283.png",
                        height: 100,
                        width: 100,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        style: TextStyle(color: Colors.yellowAccent),
                        value: _userType,
                        items: [
                          DropdownMenuItem(
                              value: 'client', child: Text('Client')),
                          DropdownMenuItem(
                              value: 'driver', child: Text('Driver')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _userType = value!;
                          });
                        },
                        dropdownColor: Colors.black,
                      ),
                      SizedBox(height: 10),
                     Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  child: TextField(
    controller: _emailController,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      label: Text("Email",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      hintText: "Enter your registered email here...",
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: Icon(Icons.email),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.yellowAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
),
                      SizedBox(height: 5),
                      Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  child: TextField(
    controller: _passwordController,
    obscureText: true,
    decoration: InputDecoration(
      label: Text("Password",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      hintText: "Enter your password here...",
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: Icon(Icons.lock),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.yellowAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          },
                          child: Text(
                            "Not registred yet? Register now",
                            style: TextStyle(
                                color: Colors.yellowAccent,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_emailController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Invalid Input"),
                                content: Text(
                                    "Please enter both email and password."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          Authorization.email = _emailController.text;
                          Authorization.password = _passwordController.text;
                          if (_userType == "client") {
                            _authProvide = AuthProvider("Users/client_login");
                          } else {
                            _authProvide = AuthProvider("Users/driver_login");
                          }
                          try {
                            var loginResponse = await _authProvide!.login();
                            if (loginResponse.result == 0) {
                              //added delay because of User get method in MasterScreen
                              await Future.delayed(const Duration(seconds: 1));
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      NotificationScreen(true)));
                            } else {
                              if (context.mounted) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text("Invalid login"),
                                          content: const Text(
                                              "Invalid login credentials or user type"),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    {Navigator.pop(context)},
                                                child: const Text("OK"))
                                          ],
                                        ));
                              }
                            }
                          } on Exception catch (e) {
                            if (context.mounted) {
                              AlertHelpers.showAlert(
                                  context, "Error", e.toString());
                            }
                          }
                          print(
                              "Credentials: ${_emailController.text} : ${_passwordController.text}");
                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: Size(150, 50),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "@eCar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black87,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
