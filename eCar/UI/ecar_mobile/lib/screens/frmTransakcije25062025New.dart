import 'package:ecar_mobile/models/KategorijaTransakcije25062025/kategorijaTransakcije25062025.dart';
import 'package:ecar_mobile/models/User/user.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/kategorija_provider.dart';
import 'package:ecar_mobile/providers/transakcija_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/frmTransakcije25062025.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/utils/buildHeader_helpers.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class frmTransakcijeNew25062025 extends StatefulWidget {
  const frmTransakcijeNew25062025({super.key});

  @override
  State<frmTransakcijeNew25062025> createState() =>
      _frmTransakcijeNew25062025State();
}

class _frmTransakcijeNew25062025State extends State<frmTransakcijeNew25062025> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  SearchResult<Kategorijatransakcije25062025>? kategorije = null;
  SearchResult<User>? users = null;

  final List<String> statusi = ["Planirano", "Realizovano", "Otkazano"];
  String? status = null;
  late TransakcijaProvider provider;
  late KategorijaProvider kategorijaProvider;
  late UserProvider userProvider;
  bool isLoading = true;

@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void initState() {
    // TODO: implement initState
    _initialValue = {
      "iznos": null,
      "datumTransakcije": DateTime.now(),
      "opis": null,
      "status": null,
      "korisnikId": null,
      "kategorijaId": null
    };
    userProvider = context.read<UserProvider>();
    provider = context.read<TransakcijaProvider>();
    kategorijaProvider = context.read<KategorijaProvider>();
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    try {
      kategorije = await kategorijaProvider.get();
      users = await userProvider.get();
      status = statusi[0];
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, "${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? getisLoadingHelper()
        : MasterScreen("Review", _buildScreen());
  }

  Widget _buildScreen() {
    return SingleChildScrollView(
        child: Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Frmtransakcije25062025(),
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_back,
                        size: 30, color: Colors.black87)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: buildHeader("Dodaj transakciju"),
              ),
            ],
          ),
          _buildContent(),
          _buildButton(),
        ],
      ),
    ));
  }

  Widget _buildContent() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding:EdgeInsets.all(8.0) ,
          child: FormBuilderDropdown(
            name: 'korisnikId',
            decoration: InputDecoration(
              labelText: 'Korisnik',
            ),
            items: users?.result!
                    .map((item) => DropdownMenuItem(
                          value: item.id.toString(),
                          child: Text(
                            "${item.name} ${item.surname}",
                          ),
                        ))
                    .toList() ??
                [],
            validator: FormBuilderValidators.required(),
          ),),
         Padding(padding: EdgeInsets.all(8.0),
         child:  FormBuilderDropdown(
            name: 'kategorijaId',
            decoration: InputDecoration(
              labelText: 'Kategorija',
            ),
            items: kategorije?.result!
                    .map((item) => DropdownMenuItem(
                          value: item.id.toString(),
                          child: Text(
                            "${item.naziv}",
                          ),
                        ))
                    .toList() ??
                [],
            validator: FormBuilderValidators.required(),
          ),),
         Padding(padding: EdgeInsets.all(8.0),
         child:  FormBuilderDropdown(
            name: 'status',
            initialValue: status,
            decoration: InputDecoration(
              labelText: 'Korisnik',
            ),
            items: statusi
                    .map((item) =>
                        DropdownMenuItem(value: item, child: Text(item)))
                    .toList() ??
                [],
            validator: FormBuilderValidators.required(),
          ),),
          Padding(padding: EdgeInsets.all(8.0),
          child: FormBuilderTextField(name: "iznos",
          decoration: InputDecoration(labelText: "Iznos"),),),
          Padding(padding: EdgeInsets.all(8.0),
          child: FormBuilderDateTimePicker(
            name: 'datumTransakcije',
            decoration: InputDecoration(
              labelText: 'Datum  transakcije',
              fillColor: Colors.white,
            ),
            inputType: InputType.date,
            firstDate: DateTime.now(),
            validator: FormBuilderValidators.required(),
          ),),
          Padding(padding: EdgeInsets.all(8.0),
          child: FormBuilderTextField(
            name: 'opis',
            decoration: InputDecoration(
              labelText: 'Opis',
              prefixIcon: Icon(Icons.drive_eta, color: Colors.black54),
            ),
            enabled: true,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),),
        ]),
      ),
    );
  }

  Widget _buildButton() {
    return Center(
      child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text("Save"),
                onPressed: () {
                  _sendReviewRequest();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    minimumSize: Size(150, 50)),
              )
            ],
          )),
    );
  }

  void _sendReviewRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      var formData = _formKey.currentState?.value;

      var request = {
        "iznos": 50.0,
        "datumTransakcije":
            DateTime.now().toIso8601String(),
        "opis": "madosa",
        "status": "sadsadd",
        "korisnikId": 1,
        "kategorijaId": 1
      };
      try {
        await provider.insert(request);
        ScaffoldHelpers.showScaffold(context, "Your drive has been reviewed");
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Frmtransakcije25062025(),
          ),
        );
      } catch (e) {
        ScaffoldHelpers.showScaffold(context, e.toString());
      }
    }
  }
  /* var request = {
        "iznos": 50.0,
        "datumTransakcije":
            (formData!['datumTransakcije'] as DateTime).toIso8601String(),
        "opis": formData['opis'],
        "stautus": formData!['status'],
        "korisnikId": formData['korisnikId'],
        "kategorijaId": formData!['kategorijaId']
      };*/
}
