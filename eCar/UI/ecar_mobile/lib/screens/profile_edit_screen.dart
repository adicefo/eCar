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
  Map<String,dynamic> _initialValue = {
  };
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
                        provider.updatePassword(widget.user!.id, request);
                        ScaffoldHelpers.showScaffold(context, "Password has been changed successfully!");
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
    super.initState();
    provider = context.read<UserProvider>();
    _initialValue = {
      "name": widget?.user?.name,
      "surname": widget?.user?.surname,
      "telephoneNumber": widget?.user?.telephoneNumber,
      "email": widget?.user?.email,
      "userName": widget?.user?.userName,
      "gender": widget?.user?.gender ?? "Male",
    };
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildHeader("Edit your profile"),
            ],
          ),
          SizedBox(
            height: 45, 
          ),
          _buildForm(),
          SizedBox(
            height: 30,
          ),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    RegExp phoneExp = new RegExp(r"^06\d-\d{3}-\d{3,4}$");
    RegExp emailExp = new RegExp(
        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?\$");
    RegExp nameSurname = new RegExp(r"[A-Z][a-z]{2,}");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.amber.shade100,
                    child: Icon(Icons.person, size: 50, color: Colors.amber),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Edit Your Profile",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Update your personal information",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 30),

            _buildSectionHeader("Personal Information", Icons.person_outline),
            SizedBox(height: 15),

            FormBuilderTextField(
              name: "name",
              enabled: true,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              decoration: _buildInputDecoration(
                "Name", 
                "Enter your first name", 
                Icons.person
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Name is required"),
                FormBuilderValidators.minLength(3,
                    errorText: "Name must contain at least 3 characters"),
                FormBuilderValidators.match(nameSurname,
                    errorText: "Name must start with an uppercase"),
              ]),
            ),
            SizedBox(height: 15),

            FormBuilderTextField(
              name: "surname",
              enabled: true,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              decoration: _buildInputDecoration(
                "Surname", 
                "Enter your last name", 
                Icons.person_outline
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Surname is required"),
                FormBuilderValidators.minLength(3,
                    errorText: "Surname must contain at least 3 characters"),
                FormBuilderValidators.match(nameSurname,
                    errorText: "Surname must start with an uppercase"),
              ]),
            ),
            SizedBox(height: 15),

            FormBuilderDropdown<String>(
              dropdownColor: const Color.fromARGB(255, 255, 249, 231),
              decoration: _buildInputDecoration(
                "Gender", 
                "Select your gender", 
                Icons.person_pin
              ),
              name: "gender",
              items: [
                DropdownMenuItem(
                  value: "Male",
                  child: Text("Male", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 25),

            _buildSectionHeader("Contact Information", Icons.contact_mail),
            SizedBox(height: 15),

            FormBuilderTextField(
              name: "email",
              enabled: false,

              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.red),
              decoration: _buildInputDecoration(
                "Email", 
                "Enter your email address", 
                Icons.email
              ),
              
            ),
            SizedBox(height: 15),

            FormBuilderTextField(
              name: "telephoneNumber",
              enabled: true,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              decoration: _buildInputDecoration(
                "Phone Number", 
                "Format: 06x-xxx-xxx(x)", 
                Icons.phone
              ),
              validator: FormBuilderValidators.compose([

                FormBuilderValidators.match(phoneExp,
                    errorText: "Number format: 06x-xxx-xxx(x)")
              ]),
            ),

            SizedBox(height: 25),

            _buildSectionHeader("Account Information", Icons.account_circle),
            SizedBox(height: 15),

            FormBuilderTextField(
              name: "userName",
              enabled: true,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              decoration: _buildInputDecoration(
                "Username", 
                "Enter your username", 
                Icons.alternate_email
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Username is required"),
                FormBuilderValidators.minLength(5,
                    errorText: "Username must contain at least 5 characters"),
                FormBuilderValidators.username(
                    checkNullOrEmpty: true,
                    allowDash: false,
                    allowDots: false,
                    allowUnderscore: false,
                    allowNumbers: true,
                    allowSpecialChar: true,
                    errorText: "- _ . are not allowed. Example: userUser123")
              ]),
            ),

            SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: InkWell(
                onTap: () {
                  _showChangePasswordDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber.shade300, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.amber.shade50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.2),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_reset, color: Colors.amber.shade800, size: 24),
                      SizedBox(width: 12),
                      Text(
                        "Change Password",
                        style: TextStyle(
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// method to build section header
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 24),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label, String hint, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Colors.black87, fontSize: 16),
      hintStyle: TextStyle(color: Colors.grey.shade400),
      prefixIcon: Icon(icon, color: Colors.amber.shade700),
      filled: true,
      fillColor: const Color.fromARGB(255, 255, 249, 231),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.amber.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.amber.shade400, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade500, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton.icon(
        icon: Icon(Icons.save, size: 24),
        label: Text(
          "Save Changes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ), 
        onPressed: () {
          _saveAndEdit();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          minimumSize: Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          shadowColor: Colors.amber.withOpacity(0.5),
        ),
      ),
    );
  }

  void _saveAndEdit() async {
   if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      
      bool? editConfirmation=await AlertHelpers.editConfirmation(context,text: "Are you sure you want to edit this profile data?");
      if(editConfirmation==false)
      {
        return;
      }
      
      var request = _formKey.currentState?.value;
      try {
        await provider.update(widget?.user?.id, request);
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
