import 'dart:convert';
import 'dart:io';

import 'package:ecar_admin/providers/notification_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/notification_screen.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:ecar_admin/utils/string_helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ecar_admin/models/Notification/notification.dart' as Model;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;

class NotificationDetailsScreen extends StatefulWidget {
  Model.Notification? notification;
  NotificationDetailsScreen({super.key, this.notification});

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late NotificationProvider provider;
  File? _image;
  String? _base64Image;

  @override
  void initState() {
    provider = context.read<NotificationProvider>();
    _initialValue = {
      'heading': widget.notification?.heading,
      'content_': widget.notification?.content_,
      'addingDate': widget.notification?.addingDate.toString(),
      'isForClient': widget.notification?.isForClient ?? false,
      'status': widget.notification?.status
    };

    // Initialize base64Image from notification if available
    if (widget.notification?.image != null &&
        widget.notification!.image!.isNotEmpty) {
      _base64Image = widget.notification!.image;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Notification details",
        Column(
          children: [_buildForm(), _buildImageSection(), _save()],
        ));
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
                  child: FormBuilderTextField(
                    maxLines: 5,
                    decoration: FormStyleHelpers.textFieldDecoration(
                      labelText: "Notification Heading",
                      prefixIcon: Icon(Icons.title, color: Colors.black54),
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    name: "heading",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Field is required"),
                    ]),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FormBuilderTextField(
                    maxLines: 5,
                    decoration: FormStyleHelpers.textFieldDecoration(
                      labelText: "Notification Content",
                      prefixIcon:
                          Icon(Icons.description, color: Colors.black54),
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    name: "content_",
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Field is required"),
                    ]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FormBuilderCheckbox(
                    name: "isForClient",
                    title: Text(
                      "Notification for client",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    initialValue: widget.notification?.isForClient ?? false,
                    decoration: FormStyleHelpers.checkboxDecoration(
                      labelText: "Client Notification",
                    ),
                    checkColor: Colors.black,
                    activeColor: Colors.yellowAccent,
                    controlAffinity: ListTileControlAffinity.trailing,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Field is required"),
                    ]),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }

  // New image section outside the form
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
              "Notification Image",
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
                                      Icons.notifications,
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
                        "Upload a notification image",
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
                  builder: (context) => NotificationScreen(),
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

                if (widget.notification == null) {
                  try {
                    provider.insert(request);
                    ScaffoldHelpers.showScaffold(
                        context, "Notification added successfully");
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                  }
                } else if (widget.notification != null) {
                  confirmEdit =
                      await help.AlertHelpers.editConfirmation(context);
                  if (confirmEdit == true) {
                    try {
                      provider.update(widget.notification?.id, request);
                      ScaffoldHelpers.showScaffold(
                          context, "Notification updated successfully");
                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                    }
                  }
                }
              } else {
              help.AlertHelpers.showAlert(context, "Invalid form",
                      "Form is not valid. Please fix the values");
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
