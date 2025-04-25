import 'dart:convert';
import 'dart:io';
import 'package:ecar_admin/screens/vehicle_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;
import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:ecar_admin/providers/vehicle_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:ecar_admin/utils/string_helpers.dart';
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
  File? _image;
  String? _base64Image;

  @override
  void initState() {
    provider = context.read<VehicleProvider>();
    _initialValue = {
      "available": widget.vehicle?.available,
      "averageConsumption": widget.vehicle?.averageConsumption.toString(),
      "name": widget.vehicle?.name,
      "price": widget.vehicle?.price.toString()
    };

    // Initialize base64Image from vehicle if available
    if (widget.vehicle?.image != null && widget.vehicle!.image!.isNotEmpty) {
      _base64Image = widget.vehicle!.image;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen("Vehicle details",
        Column(children: [_buildForm(), _buildImageSection(), _save()]));
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
                    name: "available",
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
                    validator: FormBuilderValidators.compose([
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
                    validator: FormBuilderValidators.compose([
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
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Price is required"),
                    ]),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }

  Widget _buildImageSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vehicle Image",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
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
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: Icon(
                                      Icons.directions_car,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upload a vehicle image",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Recommended size: less than 2MB",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: getImage,
                        icon: Icon(Icons.photo_library),
                        label: Text("Select Image"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellowAccent,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
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
                  confirmEdit = await help.AlertHelpers.editConfirmation(
                      context,
                      entity: "Vehicle");
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

  void getImage() async {
    try {
      var result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileSize = await file.length();

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
