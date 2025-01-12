import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/user_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

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
      "userName": widget.driver?.user?.userName,
      "password": "",
      "passwordConfirm": "",
      "gender": widget.driver?.user?.gender,
      "isActive": widget.driver?.user?.isActive
    };
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Driver details", Column(children: [_buildForm(), _save()]));
  }

  Widget _buildForm() {
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
                    ),
                  ),
                  SizedBox(width: 10),
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
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: FormBuilderCheckbox(
                    name: "isActive",
                    title: Text(
                      "Is user active",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                    initialValue: widget.driver?.user?.isActive,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    checkColor: Colors.black,
                    activeColor: Colors.yellowAccent,
                    controlAffinity: ListTileControlAffinity.trailing,
                  )),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _save() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              _formKey.currentState?.saveAndValidate();
              var request = Map.from(_formKey.currentState!.value);
              print(request);
              if (widget.driver == null) {
                driverProvider.insert(request);
              } else {
                userProvider.update(widget.driver?.userID, request);
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
