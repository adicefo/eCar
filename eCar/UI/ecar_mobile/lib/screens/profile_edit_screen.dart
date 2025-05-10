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
  final _formKeyPassword=GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  Map<String, dynamic> _initialValuePassword = {
    "password":"",
    "passwordConfirm":""
  };
  late UserProvider provider;
  
  void _showChangePasswordDialog(BuildContext context) {
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
            return FormBuilder(
              key: _formKeyPassword,
              initialValue: _initialValuePassword,
              child: 
            AlertDialog(
              title: Text("Change Password", 
                style: TextStyle(fontWeight: FontWeight.bold)),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter your new password",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 20),
                   FormBuilderTextField(
  name: "password",
  controller: _passwordController,
  obscureText: _obscurePassword,
  decoration: InputDecoration(
    labelText: "New Password",
    hintText: "Enter new password",
    errorText: _passwordError,
    prefixIcon: Icon(Icons.lock, color: Colors.grey.shade700),
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility : Icons.visibility_off,
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
      borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey),
    ),
    filled: true,
    fillColor: Colors.grey[200],
  ),
  style: TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(errorText: "Password is required"),
    (value) {
      final confirmPassword =
          _formKeyPassword.currentState?.fields['passwordConfirm']?.value;
      if (confirmPassword != null && value != confirmPassword) {
        return 'Password and Confirm Password must match';
      }
      return null;
    },
  ]),
),

                    SizedBox(height: 16),
                    FormBuilderTextField(
                      name: "passwordConfirm",
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Confirm new password",
                        errorText: _confirmPasswordError,
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade700),
                        
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                          
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                      validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(errorText: "Confirm password is required"),
    (value) {
      final password =
          _formKeyPassword.currentState?.fields['password']?.value;
      if (password != null && value != password) {
        return 'Password and Confirm Password must match';
      }
      return null;
    },
  ]),
                 ),
                    if (_isSubmitting) ...[
                      SizedBox(height: 20), 
                      Center(
                        child: CircularProgressIndicator(),
                      ), 
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Cancel", 
                    style: TextStyle(color: Colors.grey.shade700)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(79, 255, 255, 255),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async{
                   
                      if(_formKeyPassword.currentState?.validate() ?? false){
                        _formKeyPassword.currentState?.save();
                      var request ={
                        "password": _formKeyPassword.currentState?.value['password'],
                        "passwordConfirm": _formKeyPassword.currentState?.value['passwordConfirm'],
                      };
                      bool? editConfirmation=await AlertHelpers.changePasswordConfirmation(context);
                      if(editConfirmation==false)
                      {
                        return;
                      }
                      try {
                        provider.updatePassword(widget?.user?.id, request);
                        ScaffoldHelpers.showScaffold(context, "Password has been changed");
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      } catch (e) {
                        ScaffoldHelpers.showScaffold(context, e.toString());
                      }
                   
                  }
                  else{
                      AlertHelpers.showAlert(context, "Invalid form", "Form is not valid. Please fix values");
                  }}
                ),
              ],
            ));
          },
        );
      },
    );
  }
  
  @override
  void initState() {
    provider = context.read<UserProvider>();
    _initialValue = {
      "name": widget?.user?.name,
      "surname": widget?.user?.surname,
      "telephoneNumber": widget?.user?.telephoneNumber,
      "email": widget?.user?.email,
      "username": widget?.user?.userName,
  
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen("Profile", _buildScreen());
  }

  Widget _buildScreen() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Row(
          children: [
 Padding(padding: EdgeInsets.only(left: 10),
              child: IconButton(onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              }, icon: Icon(Icons.arrow_back,size: 30, color: Colors.black87)),
              ),
            Padding(
              padding: EdgeInsets.only(left:30),
              child:buildHeader("Edit your data!") ,
            ) ,
          ],
        ),
        SizedBox(
          height: 45, 
        ),
        _buildForm(),
        SizedBox(
          height: 30,
        ),
        _buildButton()
      ],
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
              FormBuilderValidators.match(emailExp,
                  errorText: "Email format is:name(name.surname)@something.com")
            ]),
          ),
          SizedBox(
            height: 15,
          ),
          FormBuilderTextField(
            name: "username",
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
                label: Text("Username...")),
            validator: FormBuilderValidators.compose([
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
            height: 15,
          ),
           FormBuilderDropdown<String>(
                        dropdownColor: const Color.fromARGB(255, 254, 225, 189),
                        decoration: InputDecoration(
                          labelText: "Gender",
                          labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                          filled: true,
                fillColor: Colors.grey[200],
                          prefixIcon: Icon(Icons.person_pin, color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                          disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                        name: "gender",
                        items: [
                          DropdownMenuItem(
                            value: "Male",
                            child: Text("Male", style: TextStyle(color: Colors.black, fontSize: 16)),
                          ),
                          DropdownMenuItem(
                            value: "Female",
                            child: Text("Female", style: TextStyle(color: Colors.black, fontSize: 16)),
                          ),
                        ],
                        style: TextStyle(
                          color: const Color.fromARGB(145, 254, 225, 189),
                          fontSize: 16,
                        ),
                      ),
          
          SizedBox(height: 30),
          
          InkWell(
            onTap: () => _showChangePasswordDialog(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_reset, color: Colors.black87),
                  SizedBox(width: 10),
                  Text(
                    "Change Password",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
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
      bool? editConfirmation=await AlertHelpers.editConfirmation(context,text: "Are you sure you want to edit this profile data?");
      if(editConfirmation==false)
      {
        return;
      }
      
      var request = _formKey.currentState?.value;
      try {
        provider.update(widget?.user?.id, request);
        ScaffoldHelpers.showScaffold(context, "Your data has been updated");

        await Future.delayed(const Duration(seconds: 2));
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
