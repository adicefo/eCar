import 'package:ecar_admin/models/CompanyPrice/companyPrice.dart';
import 'package:ecar_admin/models/search_result.dart';
import 'package:ecar_admin/providers/companyPrice_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/utils/alert_helpers.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyPricesScreen extends StatefulWidget {
  const CompanyPricesScreen({super.key});

  @override
  State<CompanyPricesScreen> createState() => _CompanyPricesScreenState();
}

class _CompanyPricesScreenState extends State<CompanyPricesScreen> {
  int _currentPage = 0;
  int _totalPages = 1;
  int _pageSize = 5;

  SearchResult<CompanyPrice>? data;

  CompanyPrice? price = null;

  late CompanyPriceProvider companyPriceProvider;

  bool isLoading = true;

  @override
  void initState() {
    companyPriceProvider = context.read<CompanyPriceProvider>();
    super.initState();
    _initForm();
  }

  Future<void> _initForm() async {
    try {
      var filter = {'Page': _currentPage, 'PageSize': _pageSize};

      data = await companyPriceProvider.get(filter: filter);

      price = await companyPriceProvider.getCurrentPrice();

      setState(() {
        isLoading = false;
        print("Count: ${data?.count}");
        _totalPages = (data!.count! / _pageSize).ceil();
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
            "Company price",
            Container(
                child: Column(
              children: [
                _buildAddBtn(),
                _buildResultView(),
                _buildPagination()
              ],
            )));
  }

  Widget _buildAddBtn() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () {
              AlertHelpers.showAlert(context, "Company Price Explanation",
                  "Company price entity is the list of prices per one kilometar of drive for company. It is not editable, if you want to increase or decrease price you must add new row. ");
            },
            icon: Icon(Icons.info),
            color: Colors.blue,
            iconSize: 30,
            tooltip: "Info",
          ),
          SizedBox(width: 16),
          SizedBox(
            width: 220,
            child: ElevatedButton.icon(
              onPressed: () {
                _showModal(context);
              },
              icon: Icon(Icons.add),
              label: Text("Add New Price"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              color: Colors.white,
              child: DataTable(
                columnSpacing: 25,
                columns: [
                  DataColumn(
                      label: Text("Price per kilometar",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Adding date",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Edit",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Delete",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)))
                ],
                rows: data?.result
                        .map((e) => DataRow(
                                color: WidgetStateProperty<
                                    Color?>.fromMap(<WidgetStatesConstraint, Color?>{
                                  WidgetState.hovered & WidgetState.focused:
                                      Colors.blueGrey,
                                  ~WidgetState.disabled: Colors.grey,
                                }),
                                cells: [
                                  DataCell(Text(
                                      "${e.pricePerKilometar.toString()} KM" ??
                                          " ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(Text(
                                      e.addingDate
                                              ?.toString()
                                              .substring(0, 10) ??
                                          DateTime.now()
                                              .toString()
                                              .substring(0, 10),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold))),
                                  DataCell(
                                    ElevatedButton(
                                      onPressed: () {
                                        AlertHelpers.showAlert(
                                            context,
                                            "Warning",
                                            "Due to application restriction you can not edit company price. If you want to change it you can add new.");
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.yellowAccent),
                                      ),
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool? confirmDelete = await AlertHelpers
                                            .deleteConfirmation(context);
                                        if (confirmDelete == true) {
                                          bool? confrimPricesDelete =
                                              await AlertHelpers
                                                  .deletePricesConfirmation(
                                                      context);
                                          if (confrimPricesDelete == true) {
                                            try {
                                              companyPriceProvider.delete(e.id);
                                              await Future.delayed(
                                                  const Duration(seconds: 1));
                                              data = await companyPriceProvider
                                                  .get(filter: {
                                                'Page': _currentPage,
                                                'PageSize': _pageSize
                                              });
                                              setState(() {});
                                            } catch (e) {
                                              ScaffoldHelpers.showScaffold(
                                                  context, "${e.toString()}");
                                            }
                                          }
                                        }
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.redAccent),
                                      ),
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ]))
                        .toList()
                        .cast<DataRow>() ??
                    [],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.yellowAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 0 ? _goToPreviousPage : null,
            icon: Icon(
              Icons.arrow_left,
              color: _currentPage > 0 ? Colors.black : Colors.grey,
            ),
            tooltip: 'Previous Page',
          ),
          const SizedBox(width: 16),
          if (_totalPages > 0) ...[
            Text(
              '${_currentPage + 1} of $_totalPages',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else if (_totalPages == 0) ...[
            Text(
              '0 of 0',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
          const SizedBox(width: 16),
          IconButton(
            onPressed: _currentPage < _totalPages - 1 ? _goToNextPage : null,
            icon: Icon(
              Icons.arrow_right,
              color:
                  _currentPage < _totalPages - 1 ? Colors.black : Colors.grey,
            ),
            tooltip: 'Next Page',
          ),
        ],
      ),
    );
  }

  void _goToNextPage() async {
    if (_currentPage < _totalPages - 1) {
      setState(() => _currentPage++);
      await _initForm();
    } else {
      AlertHelpers.showAlert(context, "Warning", "Something went wrong!");
    }
  }

  void _goToPreviousPage() async {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      await _initForm();
    } else {
      AlertHelpers.showAlert(context, "Warning", "Something went wrong!");
    }
  }

  void _showModal(BuildContext context) {
    TextEditingController _priceController = TextEditingController();
    bool _isSubmitting = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Price",
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Current price: ${price?.pricePerKilometar ?? '0.00'} KM per kilometer",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: _priceController,
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "New Price Per Kilometer",
                        prefixIcon: Icon(Icons.money, color: Colors.black54),
                        hintText: "Enter price in KM",
                      ),
                      style: FormStyleHelpers.textFieldTextStyle(),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : () async {
                      if (_priceController.text.isEmpty) {
                        ScaffoldHelpers.showScaffold(
                            context, "Please enter a price");
                        return;
                      }

                      setState(() {
                        _isSubmitting = true;
                      });

                      try {
                        var request = {
                          "pricePerKilometar": _priceController.text
                        };
                        await companyPriceProvider.insert(request);

                        ScaffoldHelpers.showScaffold(
                            context, "Price added successfully");
                        Navigator.of(context).pop();
                        _initForm();
                      } catch (e) {
                        ScaffoldHelpers.showScaffold(
                            context, "${e.toString()}");
                      } finally {
                        setState(() {
                          _isSubmitting = false;
                        });
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent,
                foregroundColor: Colors.black,
              ),
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
