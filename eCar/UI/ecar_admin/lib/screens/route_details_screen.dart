import 'package:ecar_admin/models/Client/client.dart';
import 'package:ecar_admin/models/Driver/driver.dart';
import 'package:ecar_admin/models/Route/route.dart' as Model;
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/client_provider.dart';
import 'package:ecar_admin/providers/driver_provider.dart';
import 'package:ecar_admin/providers/route_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
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
    clientResult = await clientProvider.get();
    driverResult = await driverProvider.get();
    setState(() {
      isLoading = false;
    });
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    decoration: InputDecoration(
                      labelText: "Source point latitude",
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
                    name: "sourcePoint_latitude",
                    enabled: !isDisabled,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: InputDecoration(
                      labelText: "Source point longitude",
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
                    name: "sourcePoint_longitude",
                    enabled: !isDisabled,
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
                  child: FormBuilderTextField(
                    decoration: InputDecoration(
                      labelText: "Destination point latitude",
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
                    name: "destinationPoint_latitude",
                    enabled: !isDisabled,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: InputDecoration(
                      labelText: "Destination point longitude",
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
                    name: "destinationPoint_longitude",
                    enabled: !isDisabled,
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
                  child: FormBuilderDropdown(
                    name: "driverID",
                    decoration: InputDecoration(
                      labelText: "Driver",
                      filled: true,
                      fillColor: Colors.grey[200],
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    enabled: !isDisabled,
                    items: driverResult?.result!
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
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FormBuilderDropdown(
                    name: "clientId",
                    decoration: InputDecoration(
                      labelText: "Client",
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
                    enabled: !isDisabled,
                    items: clientResult?.result
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
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

//TODO: Fix insert and finish edit for Route
  Widget _save() {
    bool? confirmEdit;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.route == null) ...[
            ElevatedButton(
              onPressed: () {
                _formKey.currentState?.saveAndValidate();
                final formData = _formKey.currentState?.value;
                final requestPayload = {
                  "sourcePoint": {
                    "latitude": formData!['sourcePoint_latitude'],
                    "longitude": formData!['sourcePoint_longitude'],
                    "srid": 4326,
                  },
                  "destinationPoint": {
                    "latitude": formData!['destinationPoint_latitude'],
                    "longitude": formData!['destinationPoint_longitude'],
                    "srid": 4326,
                  },
                  "clientId": formData!['clientId'],
                  "driverID": formData!['driverID'],
                };
                routeProvider.insert(requestPayload);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
                foregroundColor: Colors.black,
                minimumSize: Size(300, 50),
              ),
              child: const Text("Save"),
            ),
          ],
          if (widget.route?.status == "wait") ...[
            ElevatedButton(
              onPressed: () async {
                bool? confirmEdit =
                    await help.AlertHelpers.editConfirmation(context);

                _formKey.currentState?.saveAndValidate();
                if (confirmEdit == true) {
                  routeProvider.update(
                      widget.route?.id, _formKey.currentState?.value);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.black,
                minimumSize: Size(150, 50),
              ),
              child: const Text("Active"),
            ),
          ] else if (widget.route?.status == "active") ...[
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                bool? confirmEdit =
                    await help.AlertHelpers.editConfirmation(context);
                if (confirmEdit == true) {
                  routeProvider.updateFinish(widget.route?.id);
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
        ],
      ),
    );
  }
}
