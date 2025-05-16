import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/providers/client_provider.dart';
import 'package:ecar_admin/providers/user_provider.dart';
import 'package:ecar_admin/screens/clients_screen.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:ecar_admin/utils/string_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';

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
  File? _image;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    clientProvider = context.read<ClientProvider>();
    userProvider = context.read<UserProvider>();
    _initialValue = {
      "name": widget.client?.user?.name,
      "surname": widget.client?.user?.surname,
      "telephoneNumber": widget.client?.user?.telephoneNumber,
      "email": widget.client?.user?.email,
      "userName": widget.client?.user?.userName,
      "image": widget.client?.image,
      "gender": widget.client?.user?.gender,
      "password": "",
      "passwordConfirm": "",
    };

    //initialize base64Image from client if available
    if (widget.client?.image != null && widget.client!.image!.isNotEmpty) {
      _base64Image = widget.client!.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Client details",
        Column(
          children: [
            _buildForm(),
            if (widget.client != null) _buildImageSection(),
            _save()
          ],
        ));
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
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Registration Date",
                        prefixIcon:
                            Icon(Icons.calendar_today, color: Colors.black54),
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      name: "registrationDate",
                      enabled: false,
                      initialValue: widget.client?.user?.registrationDate
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
                      initialValue: widget.client?.user?.gender?.startsWith("Male") ?? false ? "Male" : "Female",
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
              SizedBox(height: 20),
            ],
          ],
        ),
      ),
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
                      "Enter a new password for this client",
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
                                widget.client?.userId, request);

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

  Widget _buildImageSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : _base64Image != null && _base64Image!.isNotEmpty
                            ? StringHelpers.imageFromBase64String(_base64Image!)
                            : Image.asset(
                                'assets/images/no_image_placeholder.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderImage();
                                },
                              ),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: getImage,
                  icon: Icon(Icons.photo_library),
                  label: Text("Select Image"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //helper method for placeholder image
  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(
        Icons.person,
        size: 80,
        color: Colors.grey,
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
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ClientListScreen(),
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

                if (_base64Image != null) {
                  request['image'] = _base64Image;
                }

                if (widget.client == null) {
                  try {
                    clientProvider.insert(request);

                    ScaffoldHelpers.showScaffold(
                        context, "Client added successfully");
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ClientListScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                  }
                } else if (widget.client != null) {
                  confirmEdit = await help.AlertHelpers.editConfirmation(
                      context,
                      entity: "Client");
                  if (confirmEdit == true) {
                    try {
                      request.remove('password');
                      request.remove('passwordConfirm');

                      request.remove('registrationDate');

                      clientProvider.update(widget.client?.id, request);

                      ScaffoldHelpers.showScaffold(
                          context, "Client updated successfully");
                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => ClientListScreen(),
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

  void getImage() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();

        if (fileSize > 2 * 1024 * 1024) {
          ScaffoldHelpers.showScaffold(
              context, "Image too large. Please select an image under 2MB.");
          return;
        }

        setState(() {
          _image = file;
          _base64Image = base64Encode(_image!.readAsBytesSync());
        });
      }
    } catch (e) {
      ScaffoldHelpers.showScaffold(
          context, "Error selecting image: ${e.toString()}");
    }
  }
}
