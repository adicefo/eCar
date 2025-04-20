import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/user_provider.dart';
import 'package:ecar_admin/screens/drivers_screen.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
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
    RegExp phoneExp = RegExp(r"^06\d-\d{3}-\d{3,4}$");
    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?$");
    RegExp nameSurname = RegExp(r"[A-Z][a-z]{2,}");
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.driver == null) ...[
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "name",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Name is required"),
                        FormBuilderValidators.minLength(3,
                            errorText:
                                "Name must contain at least 3 characters"),
                        FormBuilderValidators.match(nameSurname,
                            errorText:
                                "Name must start with an uppercase letter"),
                      ]),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Surname",
                        prefixIcon:
                            Icon(Icons.person_outline, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "surname",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Surname is required"),
                        FormBuilderValidators.minLength(3,
                            errorText:
                                "Surname must contain at least 3 characters"),
                        FormBuilderValidators.match(nameSurname,
                            errorText:
                                "Surname must start with an uppercase letter"),
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Username",
                        prefixIcon:
                            Icon(Icons.alternate_email, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "userName",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Username is required"),
                        FormBuilderValidators.minLength(5,
                            errorText:
                                "Username must contain at least 5 characters"),
                        FormBuilderValidators.username(
                            checkNullOrEmpty: true,
                            allowDash: false,
                            allowDots: false,
                            allowUnderscore: false,
                            allowNumbers: true,
                            allowSpecialChar: true,
                            errorText:
                                "- _ . are not allowed. Example: userUser123")
                      ]),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "email",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Email is required"),
                        FormBuilderValidators.match(emailExp,
                            errorText: "Please enter a valid email address")
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      obscureText: true,
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "password",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Password is required"),
                      ]),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderTextField(
                      obscureText: true,
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Confirm password",
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "passwordConfirm",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Password confirmation is required"),
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Telephone number",
                        prefixIcon: Icon(Icons.phone, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "telephoneNumber",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.match(phoneExp,
                            errorText: "Number format: 06x-xxx-xxx(x)")
                      ]),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderDropdown<String>(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Gender",
                        prefixIcon: Icon(Icons.people, color: Colors.black54),
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
                      style: FormStyleHelpers.textFieldTextStyle(),
                    ),
                  ),
                ],
              ),
            ] else if (widget.driver != null) ...[
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "name",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Name is required"),
                        FormBuilderValidators.minLength(3,
                            errorText:
                                "Name must contain at least 3 characters"),
                        FormBuilderValidators.match(nameSurname,
                            errorText:
                                "Name must start with an uppercase letter"),
                      ]),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Surname",
                        prefixIcon:
                            Icon(Icons.person_outline, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "surname",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Surname is required"),
                        FormBuilderValidators.minLength(3,
                            errorText:
                                "Surname must contain at least 3 characters"),
                        FormBuilderValidators.match(nameSurname,
                            errorText:
                                "Surname must start with an uppercase letter"),
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Telephone number",
                        prefixIcon: Icon(Icons.phone, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "telephoneNumber",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.match(phoneExp,
                            errorText: "Number format: 06x-xxx-xxx(x)")
                      ]),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "email",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Email is required"),
                        FormBuilderValidators.match(emailExp,
                            errorText: "Please enter a valid email address")
                      ]),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      obscureText: true,
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "password",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Password is required"),
                      ]),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderTextField(
                      obscureText: true,
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Confirm password",
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "passwordConfirm",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Password confirmation is required"),
                      ]),
                    ),
                  ),
                ],
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
      padding: const EdgeInsets.all(16.0),
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
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Cancel",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                var password = _formKey.currentState?.value['password'];
                var confirmPassword =
                    _formKey.currentState?.value['passwordConfirm'];
                if (password != confirmPassword) {
                  help.AlertHelpers.showAlert(context, "Password Mismatch",
                      "Passwords do not match. Please try again.");
                  return;
                }
                var request = Map.from(_formKey.currentState!.value);
                if (widget.driver == null) {
                  try {
                    driverProvider.insert(request);

                    ScaffoldHelpers.showScaffold(
                        context, "Driver added successfully");
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

                      ScaffoldHelpers.showScaffold(
                          context, "Driver updated successfully");
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
                help.AlertHelpers.showAlert(context, "Invalid Form",
                    "Please fill all required fields correctly.");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Save",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
