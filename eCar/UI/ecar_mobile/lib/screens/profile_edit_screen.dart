import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/screens/profile_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  User? user;
  ProfileEditScreen({super.key, this.user});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late UserProvider provider;
  @override
  void initState() {
    provider = context.read<UserProvider>();
    _initialValue = {
      "name": widget?.user?.name,
      "surname": widget?.user?.surname,
      "telephoneNumber": widget?.user?.telephoneNumber,
      "email": widget?.user?.email,
      "password": "",
      "passwordConfirm": "",
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen("Profile", _buildScreen());
  }

  Widget _buildScreen() {
    return Column(
      children: [
        buildHeader("Edit your\n   data!"),
        SizedBox(
          height: 15,
        ),
        _buildForm(),
        SizedBox(
          height: 70,
        ),
        _buildButton()
      ],
    );
  }

  Widget _buildForm() {
    RegExp phoneExp = new RegExp(r"^06\d-\d{3}-\d{3,4}$");
    RegExp emailExp = new RegExp(
        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?\$");
    RegExp nameSurname = new RegExp(r"[A-Z][a-z]{2,}");
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Column(
          children: [
            FormBuilderTextField(
              name: "name",
              enabled: true,
              style: TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  label: Text("Name...")),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Field is required"),
                FormBuilderValidators.minLength(3,
                    errorText: "Name must contain at least 3 charaters"),
                FormBuilderValidators.match(nameSurname,
                    errorText: "Name must start with an uppercase"),
              ]),
            ),
            SizedBox(
              height: 15,
            ),
            FormBuilderTextField(
              name: "surname",
              enabled: true,
              style: TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  label: Text("Surname...")),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Field is required"),
                FormBuilderValidators.minLength(3,
                    errorText: "Name must contain at least 3 charaters"),
                FormBuilderValidators.match(nameSurname,
                    errorText: "Name must start with an uppercase"),
              ]),
            ),
            SizedBox(
              height: 15,
            ),
            FormBuilderTextField(
              name: "telephoneNumber",
              enabled: true,
              style: TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  label: Text("Telephone number...")),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Field is required"),
                FormBuilderValidators.match(phoneExp,
                    errorText: "Number format: 06x-xxx-xxx(x)")
              ]),
            ),
            SizedBox(
              height: 15,
            ),
            FormBuilderTextField(
              name: "email",
              enabled: true,
              style: TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  label: Text("Email...")),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Field is required"),
                FormBuilderValidators.match(emailExp,
                    errorText:
                        "Email format is:name(name.surname)@something.com")
              ]),
            ),
            SizedBox(
              height: 15,
            ),
            FormBuilderTextField(
              name: "password",
              enabled: true,
              obscureText: true,
              style: TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  label: Text("Password...")),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Field is required"),
                FormBuilderValidators.minLength(6),
              ]),
            ),
            SizedBox(
              height: 15,
            ),
            FormBuilderTextField(
              name: "passwordConfirm",
              obscureText: true,
              enabled: true,
              style: TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  label: Text("Confirm password...")),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Field is required"),
                FormBuilderValidators.minLength(6),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(79, 255, 255, 255),
                foregroundColor: Colors.black,
                minimumSize: Size(150, 50)),
            child: Text(
              "Go back",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        SizedBox(
          width: 30,
        ),
        ElevatedButton(
            onPressed: () {
              _saveAndEdit();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(79, 255, 255, 255),
                foregroundColor: Colors.black,
                minimumSize: Size(150, 50)),
            child: Text(
              "Save",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  void _saveAndEdit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      var password = _formKey.currentState?.value['password'];
      var confirmPassword = _formKey.currentState?.value['passwordConfirm'];
      if (password != confirmPassword) {
        AlertHelpers.showAlert(
            context, "Invalid form", "Form is not valid. Please fix values");
        return;
      }

      var request = _formKey.currentState?.value;
      try {
        provider.update(widget?.user?.id, request);
        ScaffoldHelpers.showScaffold(context, "Your data has been updated");

        await Future.delayed(const Duration(seconds: 3));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
      } catch (e) {
        ScaffoldHelpers.showScaffold(context, e.toString());
      }
    } else {
      AlertHelpers.showAlert(
          context, "Invalid form", "Form is not valid. Please fix values");
    }
  }
}
