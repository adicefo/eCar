import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/user_provider.dart';
import 'package:ecar_admin/screens/drivers_screen.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;

class DriverDetailsScreen extends StatefulWidget {
  Driver? driver;
  DriverDetailsScreen({super.key, this.driver});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late DriverProvider driverProvider;
  late UserProvider userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driverProvider = context.read<DriverProvider>();
    userProvider = context.read<UserProvider>();
    _initialValue = {
      "name": widget.driver?.user?.name,
      "surname": widget.driver?.user?.surname,
      "telephoneNumber": widget.driver?.user?.telephoneNumber,
      "email": widget.driver?.user?.email,
      "password": "",
      "passwordConfirm": "",
    };
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Driver details", Column(children: [_buildForm(), _save()]));
  }

  Widget _buildForm() {
    RegExp phoneExp = new RegExp(r"^06\d-\d{3}-\d{3,4}$");
    RegExp emailExp = new RegExp(
        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?\$");
    RegExp nameSurname = new RegExp(r"[A-Z][a-z]{2,}");
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (widget.driver == null) ...[
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Name",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
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
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Surname",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      name: "surname",
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
                  ),
                ],
              ),
              SizedBox(
                width: 20,
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Username",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
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
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
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
                  ),
                ],
              ),
              SizedBox(
                width: 20,
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      name: "password",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Field is required"),
                      ]),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderTextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      name: "passwordConfirm",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Field is required"),
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 80,
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Telephone number",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      name: "telephoneNumber",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.match(phoneExp,
                            errorText: "Number format: 06x-xxx-xxx(x)")
                      ]),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderDropdown<String>(
                      decoration: InputDecoration(
                        labelText: "Gender",
                        filled: true,
                        fillColor: Colors.grey[200],
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
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ] //if(driver==null)
            else if (widget.driver != null) ...[
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Name",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      name: "name",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Field is required"),
                        FormBuilderValidators.match(nameSurname,
                            errorText: "Surname must start with an uppercase"),
                        FormBuilderValidators.minLength(3,
                            errorText:
                                "Surname must contain at least 3 charaters"),
                      ]),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Surname",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      name: "surname",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Field is required"),
                        FormBuilderValidators.match(nameSurname,
                            errorText: "Surname must start with an uppercase"),
                        FormBuilderValidators.minLength(3,
                            errorText:
                                "Surname must contain at least 3 charaters"),
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Telephone number",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      name: "telephoneNumber",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.match(phoneExp,
                            errorText: "Number format: 06x-xxx-xxx(x)")
                      ]),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
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
                  ),
                ],
              ),
              SizedBox(
                width: 20,
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      name: "password",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Field is required"),
                      ]),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderTextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm password",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      name: "passwordConfirm",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Field is required"),
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 80,
                height: 10,
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _save() {
    bool? confirmEdit;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DriversListScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(300, 50),
            ),
            child: const Text("Go back"),
          ),
          SizedBox(
            width: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();

                var request = Map.from(_formKey.currentState!.value);
                var password = _formKey.currentState?.value['password'];
                var confirmPassword =
                    _formKey.currentState?.value['passwordConfirm'];
                if (password != confirmPassword) {
                  help.AlertHelpers.showAlert(context, "Invalid form",
                      "Form is not valid. Please fix the values");
                  return;
                }
                if (widget.driver == null) {
                  try {
                    driverProvider.insert(request);

                    ScaffoldHelpers.showScaffold(context, "Driver added");
                    await Future.delayed(const Duration(seconds: 3));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => DriversListScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                  }
                } else if (widget.driver != null) {
                  confirmEdit =
                      await help.AlertHelpers.editConfirmation(context);
                  if (confirmEdit == true) {
                    try {
                      userProvider.update(widget.driver?.userID, request);

                      ScaffoldHelpers.showScaffold(context, "Driver updated");
                      await Future.delayed(const Duration(seconds: 3));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => DriversListScreen(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                    }
                  }
                }
              } else {
                help.AlertHelpers.showAlert(context, "Invalid form",
                    "Form is not valid. Please fix the values");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(300, 50),
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
