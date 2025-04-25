import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class StatisticsAddDialog extends StatefulWidget {
  final SearchResult<Driver> drivers;
  final Function(int) onSave;

  const StatisticsAddDialog({
    Key? key,
    required this.drivers,
    required this.onSave,
  }) : super(key: key);

  @override
  State<StatisticsAddDialog> createState() => _StatisticsAddDialogState();
}

class _StatisticsAddDialogState extends State<StatisticsAddDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  int? _selectedDriverId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.insert_chart, color: Colors.blue),
          SizedBox(width: 8),
          Text("Add New Statistics"),
        ],
      ),
      content: Container(
        width: 500, // Set a fixed width for the dialog
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select a driver to add statistics record. This creates a new daily record for the driver.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 16),
              FormBuilderDropdown(
                name: 'driverId',
                decoration: FormStyleHelpers.dropdownDecoration(
                  labelText: 'Select Driver',
                  hintText: 'Choose a driver',
                ),
                items: widget.drivers.result
                    .map((item) => DropdownMenuItem(
                          value: item.id,
                          child: Text(
                            "${item.user?.name} ${item.user?.surname}",
                          ),
                        ))
                    .toList(),
                style: FormStyleHelpers.textFieldTextStyle(),
                validator: FormBuilderValidators.required(
                    errorText: "Please select a driver"),
                onChanged: (value) {
                  setState(() {
                    _selectedDriverId = value as int?;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (_formKey.currentState?.saveAndValidate() ?? false) {
              if (_selectedDriverId != null && _selectedDriverId != 0) {
                Navigator.of(context).pop();
                widget.onSave(_selectedDriverId!);
              } else {
                AlertHelpers.showAlert(context, "Invalid Form",
                    "Please select a driver to continue.");
              }
            }
          },
          icon: Icon(Icons.save),
          label: Text("Save"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellowAccent,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
