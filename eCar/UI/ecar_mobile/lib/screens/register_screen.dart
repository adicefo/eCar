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
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.yellowAccent,
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
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.yellowAccent,
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
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.yellowAccent,
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
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.yellowAccent,
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
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.yellowAccent,
                        ),
                        name: "password",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Field is required"),
                          FormBuilderValidators.minLength(6),
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password confirm",
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.yellowAccent,
                        ),
                        name: "passwordConfirm",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Field is required"),
                          FormBuilderValidators.minLength(6),
                        ]),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FormBuilderTextField(
                        decoration: InputDecoration(
                          labelText: "Telephone number",
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.yellowAccent,
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
                          filled: true,
                          fillColor: Colors.black,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        name: "gender",
                        items: [
                          DropdownMenuItem(
                            value: "Male",
                            child: Text("Male"),
                          ),
                          DropdownMenuItem(
                            value: "Female",
                            child: Text("Female"),
                          ),
                        ],
                        style: TextStyle(
                          color: Colors.yellowAccent,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
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
                        child: Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            foregroundColor: Colors.black,
                            minimumSize: Size(300, 50)),
                      )
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
