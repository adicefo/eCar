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
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;

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
      child: Column(
        children: [
          if (widget.rent == null) ...[
            SizedBox(height: 15),
            FormBuilderDateTimePicker(
              name: 'rentingDate',
              decoration: InputDecoration(
                labelText: 'Renting Date',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              inputType: InputType.date,
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 20),
            FormBuilderDateTimePicker(
              name: 'endingDate',
              decoration: InputDecoration(
                labelText: 'Ending Date',
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              inputType: InputType.date,
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 20),
            FormBuilderDropdown(
              name: 'clientId',
              decoration: InputDecoration(
                labelText: 'Client',
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              items: clientResult?.result!
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
            ),
            const SizedBox(height: 20),
            FormBuilderDropdown(
              name: 'vehicleId',
              decoration: InputDecoration(
                labelText: 'Vehicle',
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              items: vehicleResult?.result!
                      .map((item) => DropdownMenuItem(
                            value: item.id.toString(),
                            child: Text(
                              "${item.name}",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ))
                      .toList() ??
                  [],
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 20),
          ] else if (widget.rent != null) ...[
            SizedBox(height: 15),
            FormBuilderDateTimePicker(
              name: 'endingDate',
              decoration: InputDecoration(
                labelText: 'Ending Date',
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              inputType: InputType.date,
              validator: FormBuilderValidators.required(),
            ),
            SizedBox(
              height: 20,
            ),
            FormBuilderDropdown(
              name: 'vehicleId',
              decoration: InputDecoration(
                labelText: 'Vehicle',
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              items: vehicleResult?.result!
                      .map((item) => DropdownMenuItem(
                            value: item.id.toString(),
                            child: Text(
                              "${item.name}",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ))
                      .toList() ??
                  [],
              validator: FormBuilderValidators.required(),
            ),
          ]
        ],
      ),
    );
  }

//TODO: Add update finish logic
  Widget _save() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
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
              minimumSize: Size(300, 50),
            ),
            child: const Text("Go back"),
          ),
          SizedBox(
            width: 30,
          ),
          if (widget?.rent?.status != "active")
            ElevatedButton(
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
                minimumSize: Size(300, 50),
              ),
              child: const Text("Save"),
            ),
          if (widget?.rent?.status == "active")
            ElevatedButton(
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
                minimumSize: Size(300, 50),
              ),
              child: const Text("Finish"),
            ),
        ],
      ),
    );
  }
}
