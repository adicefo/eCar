import 'dart:convert';
import 'dart:io';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;
import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:ecar_admin/providers/vehicle_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
    // TODO: implement initState
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
          padding: const EdgeInsets.all(8.0),
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
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                    initialValue: widget.vehicle?.available,
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
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: InputDecoration(
                      labelText: "Average conspumtion",
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
                    name: "averageConsumption",
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 50,
              height: 10,
            ),
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
                      labelText: "Price",
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
                    name: "price",
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 50,
              height: 10,
            ),
            //TODO: Finish logic with adding image
            Row(
              children: [
                Expanded(
                    child: FormBuilderField(
                  name: "image",
                  builder: (field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Select image",
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.image),
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

  File? _image;
  String? _base64Image;
  void getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
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
              _formKey.currentState?.saveAndValidate();
              var request = Map.from(_formKey.currentState!.value);
              request['image'] = _base64Image;
              confirmEdit = await help.AlertHelpers.editConfirmation(context);
              if (widget.vehicle == null) {
                provider.insert(request);
              } else if (widget.vehicle != null && confirmEdit == true) {
                provider.update(widget.vehicle?.id, request);
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
