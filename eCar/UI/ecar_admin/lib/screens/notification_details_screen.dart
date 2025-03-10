import 'dart:convert';
import 'dart:io';

import 'package:ecar_admin/providers/notification_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/notification_screen.dart';
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
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            if (widget.notification == null) ...[
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Heading",
                        filled: true,
                        fillColor: Colors.grey[200],
                        alignLabelWithHint: true,
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
                      name: "heading",
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderTextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Content",
                        filled: true,
                        hintMaxLines: 5,
                        fillColor: Colors.grey[200],
                        alignLabelWithHint: true,
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
                      name: "content_",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
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
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderCheckbox(
                      name: "isForClient",
                      title: Text(
                        "Notification for client",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15),
                      ),
                      initialValue: widget.notification?.isForClient,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
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
                ],
              ),
            ] else if (widget.notification != null) ...[
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Heading",
                        filled: true,
                        fillColor: Colors.grey[200],
                        alignLabelWithHint: true,
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
                      name: "heading",
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FormBuilderTextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Content",
                        filled: true,
                        hintMaxLines: 5,
                        fillColor: Colors.grey[200],
                        alignLabelWithHint: true,
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
                      name: "content_",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
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
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderCheckbox(
                      name: "isForClient",
                      title: Text(
                        "Notification for client",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15),
                      ),
                      initialValue: widget.notification?.isForClient,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
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
                        labelText: "Status",
                        filled: true,
                        hintMaxLines: 5,
                        fillColor: Colors.grey[200],
                        alignLabelWithHint: true,
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
                      name: "status",
                    ),
                  ),
                ],
              ),
            ]
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
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              minimumSize: Size(300, 50),
            ),
            child: const Text("Go back"),
          ),
          SizedBox(
            width: 30,
          ),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState?.saveAndValidate();
              var request = Map.from(_formKey.currentState!.value);
              request['image'] = _base64Image;
              if (widget.notification == null) {
                try {
                  provider.insert(request);
                  ScaffoldHelpers.showScaffold(context, "Notification added");
                  await Future.delayed(const Duration(seconds: 3));
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
                        context, "Notification updated");
                    await Future.delayed(const Duration(seconds: 3));
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
              minimumSize: Size(300, 50),
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
