import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/Route/route.dart' as Model;
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/client_provider.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/route_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/routes_screen.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;

class RouteDetailsScreen extends StatefulWidget {
  Model.Route? route;

  RouteDetailsScreen({super.key, this.route});
  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  SearchResult<Client>? clientResult;
  SearchResult<Driver>? driverResult;

  late RouteProvider routeProvider;
  late ClientProvider clientProvider;
  late DriverProvider driverProvider;

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    routeProvider = context.read<RouteProvider>();
    clientProvider = context.read<ClientProvider>();
    driverProvider = context.read<DriverProvider>();

    _initialValue = {
      "sourcePoint_latitude": widget.route?.sourcePoint?.latitude.toString(),
      "sourcePoint_longitude": widget.route?.sourcePoint?.longitude.toString(),
      "destinationPoint_latitude":
          widget.route?.destinationPoint?.latitude.toString(),
      "destinationPoint_longitude":
          widget.route?.destinationPoint?.longitude.toString(),
      "clientId": widget.route?.clientId.toString(),
      "driverID": widget.route?.driverID.toString()
    };
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  Future initForm() async {
    try {
      clientResult = await clientProvider.get();
      driverResult = await driverProvider.get();
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
        "Route details",
        Column(
          children: [isLoading ? Container() : _buildForm(), _save()],
        ));
  }

  Widget _buildForm() {
    final bool isDisabled = widget.route != null;

    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    decoration: FormStyleHelpers.textFieldDecoration(
                      labelText: "Source point latitude",
                      prefixIcon:
                          Icon(Icons.location_on, color: Colors.black54),
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    name: "sourcePoint_latitude",
                    enabled: !isDisabled,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: FormStyleHelpers.textFieldDecoration(
                      labelText: "Source point longitude",
                      prefixIcon:
                          Icon(Icons.location_on, color: Colors.black54),
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    name: "sourcePoint_longitude",
                    enabled: !isDisabled,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    decoration: FormStyleHelpers.textFieldDecoration(
                      labelText: "Destination point latitude",
                      prefixIcon:
                          Icon(Icons.location_on, color: Colors.black54),
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    name: "destinationPoint_latitude",
                    enabled: !isDisabled,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: FormStyleHelpers.textFieldDecoration(
                      labelText: "Destination point longitude",
                      prefixIcon:
                          Icon(Icons.location_on, color: Colors.black54),
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    name: "destinationPoint_longitude",
                    enabled: !isDisabled,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: FormBuilderDropdown(
                    name: "driverID",
                    decoration: FormStyleHelpers.dropdownDecoration(
                      labelText: "Driver",
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    enabled: !isDisabled,
                    items: driverResult?.result!
                            .map((item) => DropdownMenuItem(
                                  value: item.id.toString(),
                                  child: Text(
                                    "${item.user?.name} ${item.user?.surname}",
                                  ),
                                ))
                            .toList() ??
                        [],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: FormBuilderDropdown(
                    name: "clientId",
                    decoration: FormStyleHelpers.dropdownDecoration(
                      labelText: "Client",
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    enabled: !isDisabled,
                    items: clientResult?.result
                            .map((item) => DropdownMenuItem(
                                  value: item.id.toString(),
                                  child: Text(
                                    "${item.user?.name} ${item.user?.surname}",
                                  ),
                                ))
                            .toList() ??
                        [],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//TODO: Fix insert and finish edit for Route
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
                  builder: (context) => RouteListScreen(),
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
          if (widget.route == null)
            ElevatedButton.icon(
              onPressed: () async {
                _formKey.currentState?.saveAndValidate();
                var formData = _formKey.currentState?.value;

                var request = {
                  "sourcePoint": {
                    "longitude": formData!['sourcePoint_longitude'],
                    "latitude": formData!['sourcePoint_latitude']
                  },
                  "destinationPoint": {
                    "longitude": formData!['destinationPoint_longitude'],
                    "latitude": formData!['destinationPoint_latitude']
                  },
                  "driverID": formData!['driverID'],
                  "clientId": formData!['clientId']
                };

                try {
                  routeProvider.insert(request);
                  ScaffoldHelpers.showScaffold(context, "Route added");
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RouteListScreen(),
                    ),
                  );
                } catch (e) {
                  ScaffoldHelpers.showScaffold(context, "${e.toString()}");
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
}
