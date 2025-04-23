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
  TextEditingController _searchController = TextEditingController();

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
    setState(() {
      isLoading = true;
      data = null; // Clear current results to show loading indicator
    });

    try {
      var filter = {
        'Page': _currentPage,
        'PageSize': _pageSize,
        'PricePerKilometer':
            _searchController.text.isNotEmpty ? _searchController.text : null,
      };

      data = await companyPriceProvider.get(filter: filter);
      price = await companyPriceProvider.getCurrentPrice();

      setState(() {
        isLoading = false;
        if (data != null && data!.count != null) {
          _totalPages = (data!.count! / _pageSize).ceil();
          if (_totalPages < 1) _totalPages = 1;
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldHelpers.showScaffold(context, "Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Company Price",
        Column(
          children: [
            _buildSearch(),
            isLoading
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                      ),
                    ),
                  )
                : _buildResultView(),
            if (!isLoading && price != null) _buildPagination()
          ],
        ));
  }

  Widget _buildSearch() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Company Pricing",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: FormStyleHelpers.searchFieldDecoration(
                      labelText: "Price Filter",
                      hintText: "Search by price",
                    ),
                    style: FormStyleHelpers.textFieldTextStyle(),
                    onSubmitted: (_) {
                      setState(() => _currentPage = 0);
                      _initForm();
                    },
                  ),
                ),
                SizedBox(width: 24),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _currentPage = 0);
                      _initForm();
                    },
                    icon: Icon(Icons.search),
                    label: Text("Search"),
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
                SizedBox(width: 16),
                SizedBox(
                  width: 160,
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
                SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    AlertHelpers.showAlert(context, "Company Price Explanation",
                        "Company price entity is the list of prices per one kilometar of drive for company. It is not editable, if you want to increase or decrease price you must add new row.");
                  },
                  icon: Icon(Icons.info),
                  color: Colors.blue,
                  iconSize: 30,
                  tooltip: "Info",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    if (data == null || data!.result.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.attach_money,
                size: 64,
                color: Colors.black26,
              ),
              SizedBox(height: 16),
              Text(
                "No price records found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Try adjusting your search criteria or add a new price",
                style: TextStyle(
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Price History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (data != null && data!.count != null)
                    Text(
                      "${data!.result.length} of ${data!.count} prices",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              if (price != null) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        "Current Price: ${price!.pricePerKilometar} KM",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DataTable(
                      headingRowColor:
                          MaterialStateProperty.all(Colors.grey.shade100),
                      dataRowHeight: 70,
                      columnSpacing: 24,
                      horizontalMargin: 16,
                      showBottomBorder: true,
                      dividerThickness: 1,
                      headingTextStyle: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      columns: [
                        DataColumn(
                          label: Container(
                            width: 160,
                            child: Text("Price per Kilometer"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 160,
                            child: Text("Date Added"),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: 140,
                            child: Text("Actions"),
                          ),
                        ),
                      ],
                      rows: data!.result.asMap().entries.map((entry) {
                        int idx = entry.key;
                        CompanyPrice e = entry.value;
                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Colors.yellowAccent.withOpacity(0.1);
                              if (idx % 2 == 0) return Colors.grey.shade50;
                              return null;
                            },
                          ),
                          cells: [
                            DataCell(
                              Text(
                                "${e.pricePerKilometar.toString()} KM",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.addingDate?.toString().substring(0, 10) ??
                                    DateTime.now().toString().substring(0, 10),
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.grey),
                                    tooltip: "Editing not allowed",
                                    onPressed: () {
                                      AlertHelpers.showAlert(context, "Warning",
                                          "Due to application restriction you can not edit company price. If you want to change it you can add new.");
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    tooltip: "Delete price",
                                    onPressed: () async {
                                      bool? confirmDelete =
                                          await AlertHelpers.deleteConfirmation(
                                              context);
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
                                            ScaffoldHelpers.showScaffold(
                                                context,
                                                "Price deleted successfully");
                                            await _initForm();
                                          } catch (e) {
                                            ScaffoldHelpers.showScaffold(
                                                context, "${e.toString()}");
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              size: 28,
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
              size: 28,
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
      AlertHelpers.showAlert(
          context, "Warning", "You've reached the last page!");
    }
  }

  void _goToPreviousPage() async {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      await _initForm();
    } else {
      AlertHelpers.showAlert(
          context, "Warning", "You're already on the first page!");
    }
  }

  void _showModal(BuildContext context) {
    final _priceController = TextEditingController();
    bool _isSubmitting = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Add New Price"),
              content: Container(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Set a new price per kilometer for your service",
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _priceController,
                      decoration: FormStyleHelpers.textFieldDecoration(
                        labelText: "Price per Kilometer (KM)",
                        hintText: "Enter price (e.g., 1.50)",
                        prefixIcon:
                            Icon(Icons.attach_money, color: Colors.black54),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      style: FormStyleHelpers.textFieldTextStyle(),
                    ),
                    if (_isSubmitting) ...[
                      SizedBox(height: 20),
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (_priceController.text.isEmpty) {
                            ScaffoldHelpers.showScaffold(
                                context, "Please enter a price");
                            return;
                          }

                          try {
                            double price = double.parse(_priceController.text);
                            if (price <= 0) {
                              ScaffoldHelpers.showScaffold(
                                  context, "Price must be greater than 0");
                              return;
                            }

                            setState(() {
                              _isSubmitting = true;
                            });

                            var request = {"pricePerKilometar": price};
                            await companyPriceProvider.insert(request);
                            Navigator.of(context).pop();
                            ScaffoldHelpers.showScaffold(
                                context, "Price added successfully");
                            _initForm();
                          } catch (e) {
                            setState(() {
                              _isSubmitting = false;
                            });
                            ScaffoldHelpers.showScaffold(
                                context, "Error: ${e.toString()}");
                          }
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
