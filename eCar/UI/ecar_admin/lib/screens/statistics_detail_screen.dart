import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/Statistics/statistics.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/statistics_provider.dart';
import 'package:ecar_admin/screens/statistics_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import 'master_screen.dart';

class StatisticsDetailScreen extends StatefulWidget {
  const StatisticsDetailScreen({super.key});

  @override
  State<StatisticsDetailScreen> createState() => _StatisticsDetailScreenState();
}

class _StatisticsDetailScreenState extends State<StatisticsDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  SearchResult<Driver>? drivers;

  late StatisticsProvider statisticsProvider;
  late DriverProvider driverProvider;

  bool isLoading = true;
  @override
  void initState() {
    statisticsProvider = context.read<StatisticsProvider>();
    driverProvider = context.read<DriverProvider>();
    _initialValue = {"driverId": 0};
    super.initState();

    _initForm();
  }

  Future<void> _initForm() async {
    try {
      drivers = await driverProvider.get();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : MasterScreen(
            "Statistics details", Column(children: [_buildContent()]));
  }

  Widget _buildContent() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FormBuilderDropdown(
                      name: 'driverId',
                      decoration: FormStyleHelpers.dropdownDecoration(
                        labelText: 'Select Driver',
                        hintText: 'Choose a driver',
                      ),
                      items: drivers?.result
                              .map((item) => DropdownMenuItem(
                                    value: item.id.toString(),
                                    child: Text(
                                      "${item.user?.name} ${item.user?.surname}",
                                    ),
                                  ))
                              .toList() ??
                          [],
                      style: FormStyleHelpers.textFieldTextStyle(),
                      validator: FormBuilderValidators.required(
                          errorText: "Please select a driver"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => StatisticsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                      foregroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
                  ElevatedButton.icon(
                    onPressed: () async {
                      bool? confirmEdit;
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();

                        var request = Map.from(_formKey.currentState!.value);
                        confirmEdit =
                            await AlertHelpers.editConfirmation(context);
                        if (confirmEdit == true &&
                            _formKey.currentState?.value["driverId"] != 0) {
                          try {
                            statisticsProvider.insert(request);

                            ScaffoldHelpers.showScaffold(
                                context, "Statistics added successfully");
                            await Future.delayed(const Duration(seconds: 2));
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => StatisticsScreen(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldHelpers.showScaffold(
                                context, "${e.toString()}");
                          }
                        } else {
                          AlertHelpers.showAlert(context, "Invalid form",
                              "Form is not valid. Please fix the values");
                        }
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
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
