import 'dart:convert';
import 'dart:io';

import 'package:ecar_admin/providers/notification_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/notification_screen.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ecar_admin/models/Notification/notification.dart' as Model;
import 'package:flutter_form_builder/flutter_form_builder.dart';
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

  @override
  void initState() {
    // TODO: implement initState

    provider = context.read<NotificationProvider>();
    _initialValue = {
      'heading': widget.notification?.heading,
      'content_': widget.notification?.content_,
      'image': widget.notification?.image,
      'addingDate': widget.notification?.addingDate.toString(),
      'isForClient': widget.notification?.isForClient,
      'status': widget.notification?.status
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Notification details",
        Column(
          children: [_buildForm(), _save()],
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
                        labelText: "Notification Image",
                        prefixIcon: Icon(Icons.image, color: Colors.black54),
                      ),
                      child: ListTile(
                        title: Text("Select image"),
                        trailing: Icon(Icons.file_upload_outlined),
                        onTap: getImage,
                      ),
                    );
                  },
                )),
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
                    initialValue: widget.notification?.isForClient,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
              ],
            ),
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
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Cancel",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState?.saveAndValidate();
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
                confirmEdit = await help.AlertHelpers.editConfirmation(context);
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Save",
              style: TextStyle(fontWeight: FontWeight.bold),
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
