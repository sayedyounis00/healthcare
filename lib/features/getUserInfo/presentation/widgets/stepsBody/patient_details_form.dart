import 'package:flutter/material.dart';
import 'package:healthcare/core/widgets/text_form_feild.dart';
import 'package:healthcare/core/widgets/custom_dropdown.dart';

class PatientDetailsForm extends StatefulWidget {
  final void Function(bool Function())? onValidationReady;
  final void Function(Map<String, dynamic> Function())? onDataGetterReady;

  const PatientDetailsForm({
    super.key,
    this.onValidationReady,
    this.onDataGetterReady,
  });

  @override
  State<PatientDetailsForm> createState() => _PatientDetailsFormState();
}

class _PatientDetailsFormState extends State<PatientDetailsForm>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedGender;

  DateTime _selectedDate = DateTime(1950);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2010),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
      });
    }
  }

  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  Map<String, dynamic> getData() {
    return {
      'name': _nameController.text,
      'gender': _selectedGender,
      'birthDate': _selectedDate,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'address': _addressController.text,
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
    _nameController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              prefixIcon: Icons.person_outline,
              required: true,
              validator: FieldValidators.required,
            ),

            CustomDropdown<String>(
              label: 'Gender',
              hint: 'Select your gender',
              value: _selectedGender,
              items: const ['Male', 'Female'],
              prefixIcon: Icons.wc_outlined,
              required: true,
              validator: FieldValidators.required,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            CustomTextField(
              controller: _dateController,
              label: 'Birth Date',
              hint: 'Select your birth date',
              prefixIcon: Icons.calendar_today_outlined,
              onTap: () => _selectDate(context),
              validator: FieldValidators.required,
              readOnly: true,
              required: true,
            ),
            CustomTextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              label: 'Phone Number',
              hint: '+201*********',
              prefixIcon: Icons.phone_outlined,
              required: true,
              validator: FieldValidators.phone,
            ),
            CustomTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              label: 'Email',
              hint: 'example@email.com',
              prefixIcon: Icons.email_outlined,
              required: true,
              validator: FieldValidators.email,
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
