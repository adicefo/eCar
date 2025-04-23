import 'package:ecar_admin/models/Review/review.dart';
import 'package:ecar_admin/providers/review_provider.dart';
import 'package:ecar_admin/screens/master_screen.dart';
import 'package:ecar_admin/screens/review_screen.dart';
import 'package:ecar_admin/utils/form_style_helpers.dart';
import 'package:ecar_admin/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
                decoration: FormStyleHelpers.dropdownDecoration(
                  labelText: 'Rating Value',
                  hintText: 'Select rating',
                ),
                items: List.generate(
                  5,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text(
                      '${index + 1}',
                    ),
                  ),
                ),
                style: FormStyleHelpers.textFieldTextStyle(),
                onChanged: (value) {},
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: "Rating is required"),
                ]),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              flex: 3,
              child: FormBuilderTextField(
                name: 'description',
                decoration: FormStyleHelpers.textFieldDecoration(
                  labelText: 'Review Description',
                  prefixIcon: Icon(Icons.description, color: Colors.black54),
                ),
                style: FormStyleHelpers.textFieldTextStyle(),
                maxLines: 3,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: "Description is required"),
                ]),
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
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ReviewScreen(),
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
          ElevatedButton.icon(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                 _formKey.currentState?.save();
                var request = Map.from(_formKey.currentState!.value);
                confirmEdit = await help.AlertHelpers.editConfirmation(context);
                if (confirmEdit == true) {
                  try {
                    provider.update(widget.review?.id, request);

                    ScaffoldHelpers.showScaffold(
                        context, "Review updated successfully");
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ReviewScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldHelpers.showScaffold(context, "${e.toString()}");
                  }
                }
              }
              else{
                help.AlertHelpers.showAlert(context, "Invalid Form",
                    "Please fill all required fields correctly.");
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
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
