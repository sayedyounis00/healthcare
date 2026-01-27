import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcare/features/getUserInfo/domain/entities/patient.dart';
import 'package:healthcare/features/getUserInfo/presentation/cubit/patient/patient_cubit.dart';
import 'package:healthcare/features/getUserInfo/presentation/widgets/stepsBody/step_content.dart';
import 'package:healthcare/features/getUserInfo/presentation/widgets/stepper_header.dart';
import 'package:healthcare/features/getUserInfo/presentation/widgets/stepper_navigation_buttons.dart';
import 'package:healthcare/features/getUserInfo/presentation/widgets/stepper_progress_bar.dart';
import 'package:healthcare/features/home/presentation/home_view.dart';

class GetUserInfo extends StatefulWidget {
  const GetUserInfo({super.key});

  @override
  State<GetUserInfo> createState() => _GetUserInfoState();
}

class _GetUserInfoState extends State<GetUserInfo> {
  int _currentStep = 0;

  final Map<int, bool Function()> _stepValidators = {};

  final Map<int, Map<String, dynamic> Function()> _stepDataGetters = {};

  final List<String> _stepTitles = [
    'Patient Details',
    'Medical History',
    'Emergency Contact',
    'Review and Submit',
  ];

  final List<IconData> _stepIcons = [
    Icons.person_outline,
    Icons.medical_information_outlined,
    Icons.emergency_outlined,
    Icons.check_circle_outline,
  ];

  void _nextStep() {
    final validator = _stepValidators[_currentStep];
    if (validator == null || validator.call()) {
      if (_currentStep < _stepTitles.length - 1) {
        setState(() {
          _currentStep++;
        });
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _submitPatientData() async {
    bool allValid = true;
    for (int i = 0; i < _stepTitles.length - 1; i++) {
      if (_stepValidators[i] != null && !_stepValidators[i]!.call()) {
        allValid = false;
        break;
      }
      if (!allValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all required fields'),
            backgroundColor: const Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
    }

    try {
      final patientData = _stepDataGetters[0]?.call() ?? {};
      final medicalData = _stepDataGetters[1]?.call() ?? {};
      final emergencyData = _stepDataGetters[2]?.call() ?? {};

      final patient = Patient(
        name: patientData['name'] ?? '',
        gender: patientData['gender'] ?? '',
        birthDate: patientData['birthDate'] ?? DateTime.now(),
        phone: patientData['phone'] ?? '',
        email: patientData['email'] ?? '',
        address: patientData['address'] ?? '',
        bloodType: medicalData['bloodType'] ?? '',
        emergencyContactName: emergencyData['emergencyContactName'] ?? '',
        emergencyContactPhone: emergencyData['emergencyContactPhone'] ?? '',
        emergencyContactAlternativePhone:
            emergencyData['emergencyContactAlternativePhone'] ?? '',
        emergencyContactRelationship:
            emergencyData['emergencyContactRelationship'] ?? '',
        emergencyContactAddress: emergencyData['emergencyContactAddress'] ?? '',
        chronicConditions:
            (medicalData['chronicConditions'] as List<String>?) ?? [],
        allergies: (medicalData['allergies'] as List<String>?) ?? [],
        currentMedications: [],
      );
      context.read<PatientCubit>().createPatient(patient);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error preparing data: $e'),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientCubit, PatientState>(
      listener: (context, state) {
        if (state is PatientLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                const Center(child: CircularProgressIndicator()),
          );
        } else if (state is PatientSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeView()),
          );
        } else if (state is PatientFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: const Color(0xFFE53935),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: StepperHeader(
                  currentStep: _currentStep,
                  stepTitles: _stepTitles,
                  stepIcons: _stepIcons,
                ),
              ),
              // Step Counter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _stepTitles[_currentStep],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2196F3),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    Text(
                      '${(((_currentStep + 1) / _stepTitles.length) * 100).toInt()}% Complete',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2196F3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              StepperProgressBar(
                currentStep: _currentStep,
                totalSteps: _stepTitles.length,
              ),
              const SizedBox(height: 24),
              // Body Content Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: StepContent(
                    currentStep: _currentStep,
                    onValidationReady: (validateFn, stepIndex) {
                      _stepValidators[stepIndex] = validateFn;
                    },
                    onDataGetterReady: (dataGetterFn, stepIndex) {
                      _stepDataGetters[stepIndex] = dataGetterFn;
                    },
                    stepDataGetters: _stepDataGetters,
                  ),
                ),
              ),
              // Bottom Navigation Buttons
              StepperNavigationButtons(
                currentStep: _currentStep,
                totalSteps: _stepTitles.length,
                onNext: _nextStep,
                onPrevious: _previousStep,
                onSubmit: _submitPatientData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
