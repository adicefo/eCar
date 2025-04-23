import 'dart:convert';
import 'dart:io';
import 'package:ecar_admin/screens/vehicle_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;
import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:ecar_admin/providers/vehicle_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class VehicleDetailsScreen extends StatefulWidget {
  Vehicle? vehicle;
  VehicleDetailsScreen({super.key, this.vehicle});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late VehicleProvider provider;

  @override
  void initState() {
    provider = context.read<VehicleProvider>();
    _initialValue = {
      "available": widget?.vehicle?.available,
      "averageConsumption": widget?.vehicle?.averageConsumption.toString(),
      "name": widget.vehicle?.name,
      "image": widget.vehicle?.image ?? " ",
      "price": widget.vehicle?.price.toString()
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Vehicle details", Column(children: [_buildForm(), _save()]));
  }

  Widget _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderCheckbox(
                    name: "Available",
                    title: Text(
                      "Availability of car",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    initialValue: widget.vehicle?.available,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            BorderSide(color: Colors.grey.shade400, width: 1.5),
                      ),
                    ),
                    checkColor: Colors.black,
                    activeColor: Colors.yellowAccent,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: FormStyleHelpers.textFieldDecoration(
                      labelText: "Average Consumption (l/km)",
                      prefixIcon:
                          Icon(Icons.local_gas_station, color: Colors.black54),
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    name: "averageConsumption",
                    validator:FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Average conspumption is required"),
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
                      labelText: "Vehicle Name",
                      prefixIcon:
                          Icon(Icons.directions_car, color: Colors.black54),
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    name: "name",
                    validator:FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Name is required"),
                      ]),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: FormStyleHelpers.textFieldDecoration(
                      labelText: "Price",
                      prefixIcon:
                          Icon(Icons.attach_money, color: Colors.black54),
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    name: "price",
                    validator:FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "Price is required"),
                      ]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: FormBuilderField(
                  name: "image",
                  builder: (field) {
                    return InputDecorator(
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Vehicle Image",
                        prefixIcon: Icon(Icons.image, color: Colors.black54),
                      ),
                      child: ListTile(
                        title: Text("Select image"),
                        trailing: Icon(Icons.file_upload_outlined),
                        onTap: getImage,
                      ),
                    );
                  },
                ))
              ],
            )
          ]),
        ));
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
                  builder: (context) => VehicleScreen(),
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
                if (widget.vehicle == null) {
                  
                  try {
                    provider.insert(request);
                    ScaffoldHelpers.showScaffold(
                        context, "Vehicle added successfully");
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => VehicleScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                  }
                } else if (widget.vehicle != null) {
                  confirmEdit =
                      await help.AlertHelpers.editConfirmation(context);
                  if (confirmEdit == true) {
                    try {
                      provider.update(widget.vehicle?.id, request);
                      ScaffoldHelpers.showScaffold(
                          context, "Vehicle updated successfully");
                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => VehicleScreen(),
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

  File? _image;
  String? _base64Image;
  void getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }
}
