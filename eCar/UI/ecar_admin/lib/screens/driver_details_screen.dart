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
      "userName": widget.driver?.user?.userName,
      "gender": widget.driver?.user?.gender,
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
    return  Card(
  elevation: 3,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child:  FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          child:Column(
          children: [
            if (widget.driver == null) ...[
              Text(
                "Add driver",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 20,),
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
                      validator: (value) {
                        final confirmPassword = _formKey
                            .currentState?.fields['passwordConfirm']?.value;
                        if (_formKey.currentState?.fields['passwordConfirm'] !=
                                null &&
                            confirmPassword != null &&
                            value != confirmPassword) {
                          return 'Password and Confirm Password must be equal';
                        }
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
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
                      validator: (value) {
                        final password =
                            _formKey.currentState?.fields['password']?.value;
                        if (value != password) {
                          return 'Password and Confirm Password must be equal';
                        }
                        if (value == null || value.isEmpty) {
                          return 'Password confirmation is required';
                        }
                        return null;
                      },
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
                      initialValue: widget?.driver?.user?.gender,
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
              Text(
                "Edit driver",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 20,),
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
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Registration Date",
                        prefixIcon:
                            Icon(Icons.calendar_today, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "registrationDate",
                      enabled: false,
                      initialValue: widget.driver?.user?.registrationDate
                              ?.toString()
                              .substring(0, 10) ??
                          DateTime.now().toString().substring(0, 10),
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
                      initialValue: widget.driver?.user?.gender?.startsWith("Male") ?? false ? "Male" : "Female",
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
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Number of Clients",
                        prefixIcon:
                            Icon(Icons.people_outline, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "numberOfClients",
                      enabled: false,
                      initialValue:
                          widget.driver?.numberOfClientsAmount.toString(),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: FormBuilderTextField(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Number of Hours",
                        prefixIcon:
                            Icon(Icons.access_time, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "numberOfHours",
                      enabled: false,
                      initialValue:
                          widget.driver?.numberOfHoursAmount.toString(),
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
                    child: InkWell(
                      onTap: () => _showPasswordUpdateDialog(context),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lock_reset, color: Colors.blue),
                                SizedBox(width: 12),
                                Text(
                                  "Update Password",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        )
      ),
    )
);
    
    
    
  }

  void _showPasswordUpdateDialog(BuildContext context) {
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    bool _obscurePassword = true;
    bool _obscureConfirmPassword = true;
    String? _passwordError;
    String? _confirmPasswordError;
    bool _isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Update Password"),
              content: Container(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter a new password for this driver",
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        hintText: "Enter new password",
                        errorText: _passwordError,
                        prefixIcon: Icon(Icons.lock, color: Colors.black54),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Confirm new password",
                        errorText: _confirmPasswordError,
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Colors.black54),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    if (_isSubmitting) ...[
                      SizedBox(height: 20),
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.yellowAccent),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          setState(() {
                            _passwordError = null;
                            _confirmPasswordError = null;
                          });

                          if (_passwordController.text.isEmpty) {
                            setState(() {
                              _passwordError = "Password is required";
                            });
                            return;
                          }

                          if (_confirmPasswordController.text.isEmpty) {
                            setState(() {
                              _confirmPasswordError =
                                  "Please confirm your password";
                            });
                            return;
                          }

                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            setState(() {
                              _confirmPasswordError = "Passwords do not match";
                            });
                            return;
                          }

                          setState(() {
                            _isSubmitting = true;
                          });

                          try {
                            var request = {
                              "password": _passwordController.text,
                              "passwordConfirm":
                                  _confirmPasswordController.text,
                            };

                            await userProvider.updatePassword(
                                widget.driver?.userID, request);

                            Navigator.of(context).pop();
                            ScaffoldHelpers.showScaffold(
                                context, "Password updated successfully");
                          } catch (e) {
                            setState(() {
                              _isSubmitting = false;
                            });
                            ScaffoldHelpers.showScaffold(
                                context, "Error: ${e.toString()}");
                          }
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _save() {
    bool? confirmEdit;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DriversListScreen(),
                ),
              );
            },
            icon: Icon(Icons.arrow_back),
            label: Text(
              "Go back",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();

                var request = Map.from(_formKey.currentState!.value);

                if (widget.driver == null) {
                  try {
                    driverProvider.insert(request);

                    ScaffoldHelpers.showScaffold(
                        context, "Driver added successfully");
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => DriversListScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                  }
                } else if (widget.driver != null) {
                  confirmEdit = await help.AlertHelpers.editConfirmation(
                      context,
                      entity: "Driver");
                  if (confirmEdit == true) {
                    try {
                      request.remove('password');
                      request.remove('passwordConfirm');

                      request.remove('numberOfClients');
                      request.remove('numberOfHours');
                      request.remove('registrationDate');

                      driverProvider.update(widget.driver?.id, request);

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
            icon: Icon(Icons.save),
            label: Text(
              "Save",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
