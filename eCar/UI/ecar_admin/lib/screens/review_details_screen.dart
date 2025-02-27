import 'package:ecar_admin/models/Review/review.dart';
import 'package:ecar_admin/providers/review_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/review_screen.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:ecar_admin/utils/alert_helpers.dart' as help;

class ReviewDetailsScreen extends StatefulWidget {
  Review? review;
  ReviewDetailsScreen({super.key, this.review});

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  late ReviewProvider provider;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  @override
  void initState() {
    provider = context.read<ReviewProvider>();
    _initialValue = {
      "value": widget.review?.value,
      "description": widget?.review?.description,
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
        "Review details",
        Column(
          children: [_buildForm(), _save()],
        ));
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: FormBuilderDropdown<int>(
                name: 'value',
                initialValue: widget.review?.value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Value',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                dropdownColor: Colors.white,
                items: List.generate(
                  5,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              flex: 3,
              child: FormBuilderTextField(
                name: 'description',
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _save() {
    bool? confirmEdit;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState?.saveAndValidate();
              var request = Map.from(_formKey.currentState!.value);
              confirmEdit = await help.AlertHelpers.editConfirmation(context);
              if (confirmEdit == true) {
                try {
                  provider.update(widget.review?.id, request);

                  ScaffoldHelpers.showScaffold(context, "Review updated");
                  await Future.delayed(const Duration(seconds: 3));
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(),
                    ),
                  );
                } catch (e) {
                  ScaffoldHelpers.showScaffold(context, "${e.toString()}");
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
    );
  }
}
