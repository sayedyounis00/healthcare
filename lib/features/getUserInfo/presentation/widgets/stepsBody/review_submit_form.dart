import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';
import 'package:healthcare/core/di/injection.dart' as di;
import 'package:healthcare/features/getUserInfo/data/datasource/patient_local_datasource.dart';
import 'package:healthcare/features/getUserInfo/data/models/patient_model.dart';
import 'package:intl/intl.dart';

class ReviewSubmitForm extends StatefulWidget {
  final void Function(bool Function())? onValidationReady;

  const ReviewSubmitForm({super.key, this.onValidationReady});

  @override
  State<ReviewSubmitForm> createState() => _ReviewSubmitFormState();
}

class _ReviewSubmitFormState extends State<ReviewSubmitForm> {
  PatientModel? _patientData;
  bool _isLoading = true;

  bool validateForm() {
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onValidationReady?.call(validateForm);
      _loadPatientData();
    });
  }

  Future<void> _loadPatientData() async {
    try {
      final dataSource = di.sl<PatientLocalDataSource>();
      final patient = await dataSource.getPatient(1);
      setState(() {
        _patientData = patient;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_patientData == null) {
      return Center(
        child: Text(
          'No patient data found.\nPlease complete all previous steps.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.gray700),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.gray200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - Medical Document Title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.medicalBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MEDICAL RECORD',
                    style: TextStyle(
                      color: AppColors.infoLight,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Document ID: ${_patientData!.id?.toString().padLeft(6, '0') ?? 'N/A'}',
                    style: const TextStyle(
                      color: AppColors.infoLight,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Date Issued: ${DateFormat('MMMM dd, yyyy').format(DateTime.now())}',
                    style: const TextStyle(
                      color: AppColors.infoLight,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Document Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Patient Information
                  _buildSectionTitle('I. PATIENT INFORMATION'),
                  const SizedBox(height: 16),
                  _buildInfoRow('Full Name:', _patientData!.name),
                  _buildInfoRow('Gender:', _patientData!.gender),
                  _buildInfoRow(
                    'Date of Birth:',
                    DateFormat('MMMM dd, yyyy').format(_patientData!.birthDate),
                  ),
                  _buildInfoRow(
                    'Age:',
                    '${DateTime.now().year - _patientData!.birthDate.year} years',
                  ),
                  _buildInfoRow('Phone Number:', _patientData!.phone),
                  _buildInfoRow('Email Address:', _patientData!.email),
                  _buildInfoRow('Residential Address:', _patientData!.address),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // Section 2: Medical History
                  _buildSectionTitle('II. MEDICAL HISTORY'),
                  const SizedBox(height: 16),
                  _buildInfoRow('Blood Type:', _patientData!.bloodType),

                  const SizedBox(height: 12),
                  const Text(
                    'Chronic Conditions:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildList(_patientData!.chronicConditions),

                  const SizedBox(height: 12),
                  const Text(
                    'Known Allergies:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildList(_patientData!.allergies),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // Section 3: Emergency Contact
                  _buildSectionTitle('III. EMERGENCY CONTACT'),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Contact Name:',
                    _patientData!.emergencyContactName,
                  ),
                  _buildInfoRow(
                    'Relationship:',
                    _patientData!.emergencyContactRelationship,
                  ),
                  _buildInfoRow(
                    'Primary Phone:',
                    _patientData!.emergencyContactPhone,
                  ),
                  if (_patientData!.emergencyContactAlternativePhone.isNotEmpty)
                    _buildInfoRow(
                      'Alternative Phone:',
                      _patientData!.emergencyContactAlternativePhone,
                    ),
                  _buildInfoRow(
                    'Address:',
                    _patientData!.emergencyContactAddress,
                  ),

                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // Footer Note
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lighterBlue,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.lighterBlue),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: AppColors.medicalBlue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Please review all information carefully before submitting.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.medicationPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2196F3),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2196F3),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF333333),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<String> items) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Text(
          'None reported',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF999999),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '• ',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
