import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/models/Rent/rent.dart';
import 'package:ecar_admin/models/Vehicle/vehicle.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/client_provider.dart';
import 'package:ecar_admin/providers/rent_provider.dart';
import 'package:ecar_admin/providers/vehicle_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/rent_screen.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;
import 'package:intl/intl.dart';

class RentDetailsScreen extends StatefulWidget {
  Rent? rent;
  RentDetailsScreen({super.key, this.rent});

  @override
  State<RentDetailsScreen> createState() => _RentDetailsScreenState();
}

class _RentDetailsScreenState extends State<RentDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late VehicleProvider vehicleProvider;
  late ClientProvider clientProvider;
  late RentProvider rentProvider;

  SearchResult<Client>? clientResult;
  SearchResult<Vehicle>? vehicleResult;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vehicleProvider = context.read<VehicleProvider>();
    clientProvider = context.read<ClientProvider>();
    rentProvider = context.read<RentProvider>();
    _initialValue = {
      "rentingDate": widget.rent?.rentingDate,
      "endingDate": widget.rent?.endingDate,
      "clientId": widget.rent?.clientId.toString(),
      "vehicleId": widget.rent?.vehicleId.toString()
    };
    initForm();
  }

  Future initForm() async {
    try {
      vehicleResult = await vehicleProvider.get();
      clientResult = await clientProvider.get();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Rent details",
        Column(
          children: [
            isLoading
                ? Container(child: Text("Still not implemented"))
                : _buildForm(),
            SizedBox(
              height: 20,
            ),
            _save()
          ],
        ));
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            if (widget.rent == null) ...[
              SizedBox(height: 15),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  "Date Format: MM/DD/YYYY",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              FormBuilderDateTimePicker(
                name: 'rentingDate',
                decoration: FormStyleHelpers.dateFieldDecoration(
                  labelText: 'Renting Date',
                  hintText: 'Select start date (MM/DD/YYYY)',
                  fillColor: Colors.white,
                ),
                format: DateFormat('MM/dd/yyyy'),
                inputType: InputType.date,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  "Date Format: MM/DD/YYYY",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              FormBuilderDateTimePicker(
                name: 'endingDate',
                decoration: FormStyleHelpers.dateFieldDecoration(
                  labelText: 'Ending Date',
                  hintText: 'Select end date (MM/DD/YYYY)',
                  fillColor: Colors.white,
                ),
                format: DateFormat('MM/dd/yyyy'),
                inputType: InputType.date,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 35),
              FormBuilderDropdown(
                name: 'clientId',
                decoration: FormStyleHelpers.dropdownDecoration(
                  labelText: 'Client',
                ),
                items: clientResult?.result!
                        .map((item) => DropdownMenuItem(
                              value: item.id.toString(),
                              child: Text(
                                "${item.user?.name} ${item.user?.surname}",
                              ),
                            ))
                        .toList() ??
                    [],
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 35),
              FormBuilderDropdown(
                name: 'vehicleId',
                decoration: FormStyleHelpers.dropdownDecoration(
                  labelText: 'Vehicle',
                ),
                items: vehicleResult?.result!
                        .map((item) => DropdownMenuItem(
                              value: item.id.toString(),
                              child: Text(
                                "${item.name}",
                              ),
                            ))
                        .toList() ??
                    [],
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 20),
            ] else if (widget.rent != null) ...[
              SizedBox(height: 15),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  "Date Format: MM/DD/YYYY",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              FormBuilderDateTimePicker(
                name: 'endingDate',
                decoration: FormStyleHelpers.dateFieldDecoration(
                  labelText: 'Ending Date',
                  hintText: 'Select end date (MM/DD/YYYY)',
                  fillColor: Colors.white,
                ),
                format: DateFormat('MM/dd/yyyy'),
                inputType: InputType.date,
                validator: FormBuilderValidators.required(),
              ),
              SizedBox(
                height: 20,
              ),
              FormBuilderDropdown(
                name: 'vehicleId',
                decoration: FormStyleHelpers.dropdownDecoration(
                  labelText: 'Vehicle',
                ),
                items: vehicleResult?.result!
                        .map((item) => DropdownMenuItem(
                              value: item.id.toString(),
                              child: Text(
                                "${item.name}",
                              ),
                            ))
                        .toList() ??
                    [],
                validator: FormBuilderValidators.required(),
              ),
            ]
          ],
        ),
      ),
    );
  }

//TODO: Add update finish logic
  Widget _save() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => RentScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: Icon(Icons.arrow_back),
            label: const Text("Go back"),
          ),
          SizedBox(
            width: 30,
          ),
          if (widget?.rent?.status != "active")
            ElevatedButton.icon(
              onPressed: () async {
                _formKey.currentState?.saveAndValidate();
                final formData = _formKey.currentState?.value;

                if (widget.rent == null) {
                  final requestPayload = {
                    "rentingDate": (formData!['rentingDate'] as DateTime)
                        .toIso8601String(),
                    "endingDate":
                        (formData!['endingDate'] as DateTime).toIso8601String(),
                    "clientId": formData!['clientId'],
                    "vehicleId": formData!['vehicleId']
                  };
                  try {
                    rentProvider.insert(requestPayload);
                    ScaffoldHelpers.showScaffold(context, "Rent added");
                    await Future.delayed(const Duration(seconds: 3));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => RentScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                  }
                } else if (widget.rent != null) {
                  final requestPayload = {
                    "endingDate":
                        (formData!['endingDate'] as DateTime).toIso8601String(),
                    "vehicleId": formData!['vehicleId']
                  };
                  var confirmEdit =
                      await help.AlertHelpers.editConfirmation(context);
                  if (confirmEdit == true) {
                    try {
                      rentProvider.update(widget.rent?.id, requestPayload);
                      ScaffoldHelpers.showScaffold(context, "Rent updated");
                      await Future.delayed(const Duration(seconds: 3));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RentScreen(),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: Icon(Icons.save),
              label: const Text("Save"),
            ),
          if (widget?.rent?.status == "active")
            ElevatedButton.icon(
              onPressed: () async {
                bool? confirmEdit =
                    await help.AlertHelpers.editConfirmation(context);
                if (confirmEdit == true) {
                  try {
                    rentProvider.updateFinish(widget.rent?.id);
                    ScaffoldHelpers.showScaffold(
                        context, "Rent updated to finish");
                    await Future.delayed(const Duration(seconds: 3));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => RentScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              icon: Icon(Icons.check),
              label: const Text("Finish"),
            ),
        ],
      ),
    );
  }
}
