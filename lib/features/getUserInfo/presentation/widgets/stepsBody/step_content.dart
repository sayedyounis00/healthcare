import 'package:flutter/material.dart';
import 'patient_details_form.dart';
import 'medical_history_form.dart';
import 'emergency_contact_form.dart';
import 'review_submit_form.dart';

class StepContent extends StatelessWidget {
  final int currentStep;
  final void Function(bool Function(), int index)? onValidationReady;
  final void Function(Map<String, dynamic> Function(), int index)?
  onDataGetterReady;
  final Map<int, Map<String, dynamic> Function()>? stepDataGetters;

  const StepContent({
    super.key,
    required this.currentStep,
    this.onValidationReady,
    this.onDataGetterReady,
    this.stepDataGetters,
  });

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentStep,
      children: [
        PatientDetailsForm(
          onValidationReady: (validateFn) =>
              onValidationReady?.call(validateFn, 0),
          onDataGetterReady: (dataGetterFn) =>
              onDataGetterReady?.call(dataGetterFn, 0),
        ),
        MedicalHistoryForm(
          onValidationReady: (validateFn) =>
              onValidationReady?.call(validateFn, 1),
          onDataGetterReady: (dataGetterFn) =>
              onDataGetterReady?.call(dataGetterFn, 1),
        ),
        EmergencyContactForm(
          onValidationReady: (validateFn) =>
              onValidationReady?.call(validateFn, 2),
          onDataGetterReady: (dataGetterFn) =>
              onDataGetterReady?.call(dataGetterFn, 2),
        ),
        ReviewSubmitForm(
          onValidationReady: (validateFn) =>
              onValidationReady?.call(validateFn, 3),
        ),
      ],
    );
  }
}
