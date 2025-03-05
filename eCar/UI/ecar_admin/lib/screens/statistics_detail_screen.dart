import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/Statistics/statistics.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/statistics_provider.dart';
import 'package:ecar_admin/screens/statistics_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
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
    drivers = await driverProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : MasterScreen(
            "Statistics details", Column(children: [_buildContent()]));
  }

  Widget _buildContent() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 500,
                  child: FormBuilderDropdown(
                    name: 'driverId',
                    decoration: InputDecoration(
                      labelText: 'Driver',
                      filled: true,
                      fillColor: Colors.grey[200],
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    items: drivers?.result
                            .map((item) => DropdownMenuItem(
                                  value: item.id.toString(),
                                  child: Text(
                                    "${item.user?.name} ${item.user?.surname}",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ))
                            .toList() ??
                        [],
                    validator: FormBuilderValidators.required(),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
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
                                  context, "Statistics added");
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellowAccent,
                        foregroundColor: Colors.black,
                        minimumSize: Size(300, 50),
                      ),
                      child: const Text("Save"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
