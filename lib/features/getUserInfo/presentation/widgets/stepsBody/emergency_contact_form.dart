import 'package:flutter/material.dart';
import 'package:healthcare/core/widgets/text_form_feild.dart';
import 'package:healthcare/core/widgets/custom_dropdown.dart';

class EmergencyContactForm extends StatefulWidget {
  final void Function(bool Function())? onValidationReady;
  final void Function(Map<String, dynamic> Function())? onDataGetterReady;

  const EmergencyContactForm({
    super.key,
    this.onValidationReady,
    this.onDataGetterReady,
  });

  @override
  State<EmergencyContactForm> createState() => _EmergencyContactFormState();
}

class _EmergencyContactFormState extends State<EmergencyContactForm>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _alternativePhoneController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedRelationship;

  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  Map<String, dynamic> getData() {
    return {
      'emergencyContactName': _contactNameController.text,
      'emergencyContactPhone': _phoneController.text,
      'emergencyContactAlternativePhone': _alternativePhoneController.text,
      'emergencyContactRelationship': _selectedRelationship,
      'emergencyContactAddress': _addressController.text,
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
    _contactNameController.dispose();
    _phoneController.dispose();
    _alternativePhoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //-imp-// Required for AutomaticKeepAliveClientMixin
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: _contactNameController,
              label: 'Emergency Contact Name',
              hint: 'Enter full name',
              prefixIcon: Icons.person_outline,
              required: true,
              validator: FieldValidators.required,
            ),
            CustomDropdown<String>(
              label: 'Relationship',
              hint: 'Select relationship',
              value: _selectedRelationship,
              items: const [
                'Spouse',
                'Parent',
                'Child',
                'Sibling',
                'Friend',
                'Other Family Member',
                'Colleague',
                'Neighbor',
              ],
              prefixIcon: Icons.family_restroom_outlined,
              required: true,
              validator: FieldValidators.required,
              onChanged: (value) {
                setState(() {
                  _selectedRelationship = value;
                });
              },
            ),
            CustomTextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              label: 'Primary Phone Number',
              hint: '+201*********',
              prefixIcon: Icons.phone_outlined,
              required: true,
              validator: FieldValidators.phone,
            ),
            CustomTextField(
              controller: _alternativePhoneController,
              keyboardType: TextInputType.phone,
              label: 'Alternative Phone Number',
              hint: '+201********* (Optional)',
              prefixIcon: Icons.phone_android_outlined,
              required: false,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return FieldValidators.phone(value);
                }
                return null;
              },
            ),
            CustomTextField(
              controller: _addressController,
              label: 'Address',
              hint: 'Enter complete address',
              prefixIcon: Icons.location_on_outlined,
              maxLines: 3,
              required: true,
              validator: FieldValidators.required,
            ),
          ],
        ),
      ),
    );
  }
}
