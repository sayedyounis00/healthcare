import 'package:flutter/material.dart';
import 'package:healthcare/core/widgets/custom_dropdown.dart';
import 'package:healthcare/core/widgets/text_form_feild.dart';
import 'package:healthcare/features/getUserInfo/data/models/chronic_conditions.dart';
import 'package:healthcare/features/getUserInfo/presentation/widgets/multi_select_feild.dart';

class MedicalHistoryForm extends StatefulWidget {
  final void Function(bool Function())? onValidationReady;
  final void Function(Map<String, dynamic> Function())? onDataGetterReady;

  const MedicalHistoryForm({
    super.key,
    this.onValidationReady,
    this.onDataGetterReady,
  });

  @override
  State<MedicalHistoryForm> createState() => _MedicalHistoryFormState();
}

class _MedicalHistoryFormState extends State<MedicalHistoryForm>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedBloodType;
  List<String> _selectedChronicConditions = [];
  List<String> _selectedAllergies = [];

  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  Map<String, dynamic> getData() {
    return {
      'bloodType': _selectedBloodType,
      'chronicConditions': _selectedChronicConditions,
      'allergies': _selectedAllergies,
    };
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onValidationReady?.call(validateForm);
      widget.onDataGetterReady?.call(getData);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomDropdown<String>(
              label: 'Blood Type',
              hint: 'Select your blood type',
              value: _selectedBloodType,
              items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
              prefixIcon: Icons.bloodtype_outlined,
              required: true,
              validator: FieldValidators.required,
              onChanged: (value) {
                setState(() {
                  _selectedBloodType = value;
                });
              },
            ),
            ConditionsMultiSelect(
              medicalConditions: MedicalConditionLists.chronicConditions,
              initialSelected: _selectedChronicConditions,
              onChanged: (value) {
                setState(() {
                  _selectedChronicConditions = value;
                });
              },
            ),
            ConditionsMultiSelect(
              medicalConditions: MedicalConditionLists.commonAllergies,
              initialSelected: _selectedAllergies,
              onChanged: (value) {
                setState(() {
                  _selectedAllergies = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
