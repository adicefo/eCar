import 'package:ecar_mobile/models/KategorijaTransakcije25062025/kategorijaTransakcije25062025.dart';
import 'package:ecar_mobile/models/Transkacija25062025/transakcija25062025.dart';
import 'package:ecar_mobile/models/search_result.dart';
import 'package:ecar_mobile/providers/kategorija_provider.dart';
import 'package:ecar_mobile/providers/transakcija_provider.dart';
import 'package:ecar_mobile/providers/user_provider.dart';
import 'package:ecar_mobile/screens/frmTransakcije25062025New.dart';
import 'package:ecar_mobile/screens/master_screen.dart';
import 'package:ecar_mobile/utils/isLoading_helpers.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Frmtransakcije25062025 extends StatefulWidget {
  const Frmtransakcije25062025({super.key});

  @override
  State<Frmtransakcije25062025> createState() => _Frmtransakcije25062025State();
}

class _Frmtransakcije25062025State extends State<Frmtransakcije25062025> {
  DateTime? selectedDateOd;
  DateTime? selectedDateDo;

  Kategorijatransakcije25062025? selectedKategorija;
  dynamic? statTotalHrana = null;
  dynamic? statTotalZabava = null;
  dynamic? statTotalPlata = null;

  SearchResult<Transakcija25062025>? data = null;
  SearchResult<Kategorijatransakcije25062025>? kategorije = null;

  late TransakcijaProvider provider;
  late KategorijaProvider kategorijaProvider;
  late UserProvider userProvider;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    userProvider = context.read<UserProvider>();
    provider = context.read<TransakcijaProvider>();
    kategorijaProvider = context.read<KategorijaProvider>();
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    try {
      var filter = {
        "KategorijaId": selectedKategorija?.id ?? null,
        "DatumPocetka": selectedDateOd ?? null,
        "DatumZavrsetka": selectedDateDo ?? null
      };
      data = await provider.get(filter: filter);
      kategorije = await kategorijaProvider.get();
      statTotalHrana = await provider.getTotalHrana(filter);
      statTotalPlata = await provider.getTotalPlata(filter);
      statTotalZabava = await provider.getTotalZabava(filter);
      selectedKategorija = kategorije?.result.first;
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
        : MasterScreen(
            "Profile",
            SingleChildScrollView(
              child: _buildScreen(),
            ));
  }

  Widget _buildScreen() {
    return Column(
      children: [
        _buildFilters(),
        SizedBox(height: 24),
        Container(
          height: 450,
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 5,
                childAspectRatio: 2.5),
            scrollDirection: Axis.vertical,
            children: _buildContent(),
          ),
        ),
        SizedBox(height: 30),
        _buildStatistics()
      ],
    );
  }

  Widget _buildFilters() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButtonFormField<Kategorijatransakcije25062025>(
                decoration: InputDecoration(
                  labelText: "Kategorija",
                ),
                value: selectedKategorija,
                onChanged: (Kategorijatransakcije25062025? newValue) {
                  setState(() {
                    selectedKategorija = newValue;
                  });
                },
                items:
                    kategorije?.result.map((Kategorijatransakcije25062025 key) {
                  return DropdownMenuItem<Kategorijatransakcije25062025>(
                    value: key,
                    child: Text("${key?.naziv}"),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDateOd ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDateOd = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Date Od",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    selectedDateOd == null
                        ? 'Choose the date'
                        : "${selectedDateOd!.day}.${selectedDateOd!.month}.${selectedDateOd!.year}",
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDateDo ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDateDo = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Date Do",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    selectedDateDo == null
                        ? 'Choose the date'
                        : "${selectedDateDo!.day}.${selectedDateDo!.month}.${selectedDateDo!.year}",
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                _initForm();
              },
              icon: Icon(Icons.filter_list),
              label: Text("Filter"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => frmTransakcijeNew25062025(),
                  ),
                );
              },
              icon: Icon(Icons.add),
              label: Text("Dodaj"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  List<Widget> _buildContent() {
    if (data?.result.length == 0) {
      return [
        Center(
            child: Text(
          "Sorry, there is no current available elements...",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ))
      ];
    }

    List<Widget> listTrans = data!.result
        .map(
          (x) => GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 249, 231),
                    border: Border.all(color: Colors.black, strokeAlign: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(" ${x.korisnik?.name} ${x.korisnik?.surname}"),
                      Text("Kategorija ${x.kategorija?.naziv}"),
                      Text(" Opis ${x.opis}"),
                      Text("Status ${x.status}"),
                      Text(
                          "Datum ${x.datumTransakcije.toString().substring(0, 10)}"),
                      Text(" Iznos ${x.iznos}"),
                    ],
                  ),
                ),
              )),
        )
        .cast<Widget>()
        .toList();
    return listTrans;
  }

  Widget _buildStatistics() {
    return Row(
      children: [
        Text("Total hrana ${statTotalHrana['value']??0}"),
        Text("Total zabava ${statTotalZabava['value']??0}"),
        Text("Total plata ${statTotalPlata['value']??0}"),
      ],
    );
  }
}
