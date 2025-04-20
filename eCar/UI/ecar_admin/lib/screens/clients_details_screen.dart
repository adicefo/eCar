import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/providers/client_provider.dart';
import 'package:ecar_admin/providers/user_provider.dart';
import 'package:ecar_admin/screens/clients_screen.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;

class ClientsDetailsScreen extends StatefulWidget {
  Client? client;
  ClientsDetailsScreen({super.key, this.client});

  @override
  State<ClientsDetailsScreen> createState() => _ClientsDetailsScreenState();
}

class _ClientsDetailsScreenState extends State<ClientsDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ClientProvider clientProvider;
  late UserProvider userProvider;

  @override
  void initState() {
    // TODO: implement initState
    clientProvider = context.read<ClientProvider>();
    userProvider = context.read<UserProvider>();
    _initialValue = {
      "name": widget.client?.user?.name,
      "surname": widget.client?.user?.surname,
      "telephoneNumber": widget.client?.user?.telephoneNumber,
      "email": widget.client?.user?.email,
      "password": "",
      "passwordConfirm": "",
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Client details",
        Column(
          children: [_buildForm(), _save()],
        ));
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.client == null) ...[
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
                        prefixIcon: Icon(Icons.lock, color: Colors.black54),
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
                        prefixIcon: Icon(Icons.person, color: Colors.black54),
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
            ] else if (widget.client != null) ...[
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
                        prefixIcon: Icon(Icons.lock, color: Colors.black54),
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
                  builder: (context) => ClientListScreen(),
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
                var password = _formKey.currentState?.value['password'];
                var confirmPassword =
                    _formKey.currentState?.value['passwordConfirm'];
                if (password != confirmPassword) {
                  help.AlertHelpers.showAlert(context, "Invalid form",
                      "Form is not valid. Please fix the values");
                  return;
                }
                var request = Map.from(_formKey.currentState!.value);
                if (widget.client == null) {
                  try {
                    clientProvider.insert(request);

                    ScaffoldHelpers.showScaffold(context, "Client added");
                    await Future.delayed(const Duration(seconds: 3));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ClientListScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                  }
                } else if (widget.client != null) {
                  confirmEdit =
                      await help.AlertHelpers.editConfirmation(context);
                  if (confirmEdit == true) {
                    try {
                      userProvider.update(widget.client?.userId, request);

                      ScaffoldHelpers.showScaffold(context, "Client updated");
                      await Future.delayed(const Duration(seconds: 3));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ClientListScreen(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                    }
                  }
                } else {
                  help.AlertHelpers.showAlert(context, "Invalid form",
                      "Form is not valid. Please fix the values");
                }
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
