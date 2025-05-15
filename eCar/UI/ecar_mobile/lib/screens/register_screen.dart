import 'package:ecar_mobile/main.dart';
import 'package:ecar_mobile/providers/client_provider.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ClientProvider provider;
  @override
  void initState() {
    // TODO: implement initState
    _initialValue = {
      "name": "",
      "surname": "",
      "userName": "",
      "email": "",
      "password": "",
      "passwordConfirm": "",
      "telephoneNumber": "",
      "gender": "Male",
    };
    provider = context.read<ClientProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color: Colors.black,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                icon: Icon(Icons.login),
                label: Text("Login"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: Size(100, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              ),
            ),
            Text(
              "Register",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.yellowAccent,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: _buildScreen(),
        ),
      ),
    );
  }

  Widget _buildScreen() {
    RegExp phoneExp = new RegExp(r"^06\d-\d{3}-\d{3,4}$");
    RegExp emailExp = new RegExp(
        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?\$");
    RegExp nameSurname = new RegExp(r"[A-Z][a-z]{2,}");
    return Container(
      constraints: BoxConstraints(maxHeight: 1000, maxWidth: 400),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 12.0),
            child: FormBuilder(
                key: _formKey,
                initialValue: _initialValue,
                child: Card(
                  color: Colors.yellowAccent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/55283.png",
                        height: 100,
                        width: 100,
                        color: Colors.black,
                      ),
                      Text(
                        "Register now....",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: String.fromCharCode(223)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.black,
                          hintText: "Enter your first name",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: Icon(Icons.person, color: Colors.yellowAccent),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        name: "name",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Field is required"),
                          FormBuilderValidators.minLength(3,
                              errorText:
                                  "Name must contain at least 3 charaters"),
                          FormBuilderValidators.match(nameSurname,
                              errorText: "Name must start with an uppercase"),
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                          labelText: "Surname",
                          labelStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.black,
                          hintText: "Enter your last name",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: Icon(Icons.person_outline, color: Colors.yellowAccent),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        name: "surname",  
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Field is required"),
                          FormBuilderValidators.match(nameSurname,
                              errorText:
                                  "Surname must start with an uppercase"),
                          FormBuilderValidators.minLength(3,
                              errorText:
                                  "Surname must contain at least 3 charaters"),
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.black,
                          hintText: "Create a username",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: Icon(Icons.account_circle, color: Colors.yellowAccent),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        name: "userName",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Field is required"),
                          FormBuilderValidators.minLength(5,
                              errorText:
                                  "Username must contain at least 5 charaters"),
                          FormBuilderValidators.username(
                              checkNullOrEmpty: true,
                              allowDash: false,
                              allowDots: false,
                              allowUnderscore: false,
                              allowNumbers: true,
                              allowSpecialChar: true,
                              errorText:
                                  "- _ . are not allowed. Correct example: userUser123")
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.black,
                          hintText: "Enter your email address",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: Icon(Icons.email, color: Colors.yellowAccent),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        name: "email",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Field is required"),
                          FormBuilderValidators.match(emailExp,
                              errorText:
                                  "Email format is:name(name.surname)@something.com")
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.black,
                          hintText: "Create a secure password",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: Icon(Icons.lock, color: Colors.yellowAccent),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        name: "password",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Field is required"),
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.black,
                          hintText: "Re-enter your password",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.yellowAccent),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        name: "passwordConfirm",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Field is required"),
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                          labelText: "Telephone Number",
                          labelStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.black,
                          hintText: "Format: 06x-xxx-xxx(x)",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                          prefixIcon: Icon(Icons.phone, color: Colors.yellowAccent),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        name: "telephoneNumber",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.match(phoneExp,
                              errorText: "Number format: 06x-xxx-xxx(x)")
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderDropdown<String>(
                        dropdownColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: "Gender",
                          labelStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          filled: true,
                          fillColor: Colors.black,
                          prefixIcon: Icon(Icons.person_pin, color: Colors.yellowAccent),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.yellowAccent, width: 2.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                        name: "gender",
                        items: [
                          DropdownMenuItem(
                            value: "Male",
                            child: Text("Male", style: TextStyle(color: Colors.yellowAccent, fontSize: 16)),
                          ),
                          DropdownMenuItem(
                            value: "Female",
                            child: Text("Female", style: TextStyle(color: Colors.yellowAccent, fontSize: 16)),
                          ),
                        ],
                        style: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        icon: Icon(Icons.app_registration),
                        label: Text("Register",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            var password =
                                _formKey.currentState?.value['password'];
                            var confirmPassword =
                                _formKey.currentState?.value['passwordConfirm'];
                            if (password != confirmPassword) {
                              AlertHelpers.showAlert(context, "Invalid form",
                                  "Form is not valid. Please fix the values");
                              return;
                            }

                            var request = _formKey.currentState?.value;
                            provider.insert(request);
                            ScaffoldHelpers.showScaffold(
                                context, "Registration valid");

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          } else {
                            AlertHelpers.showAlert(context, "Invalid form",
                                "Form is not valid. Please fix the values");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            foregroundColor: Colors.black,
                            minimumSize: Size(300, 50)),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "@eCar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
