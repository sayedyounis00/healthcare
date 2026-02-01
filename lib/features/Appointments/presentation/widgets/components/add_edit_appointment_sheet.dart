import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';
import 'package:healthcare/core/widgets/text_form_feild.dart';
import 'package:healthcare/features/Appointments/data/model/appointment_model.dart';
import 'package:healthcare/features/Appointments/domain/entites/appoinment.dart';

/// Bottom sheet for adding or editing appointments
class AddEditAppointmentSheet extends StatefulWidget {
  final AppointmentModel? appointment;
  final void Function(AppointmentModel appointment) onSave;

  const AddEditAppointmentSheet({
    super.key,
    this.appointment,
    required this.onSave,
  });

  @override
  State<AddEditAppointmentSheet> createState() =>
      _AddEditAppointmentSheetState();
}

class _AddEditAppointmentSheetState extends State<AddEditAppointmentSheet> {
  late final TextEditingController _doctorNameController;
  late final TextEditingController _clinicNameController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _selectedSpecialty;
  late String _selectedType;
  late AppointmentStatus _selectedStatus;
  final _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.appointment != null;

  // Predefined specialties
  static const List<String> _specialties = [
    'General Physician',
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'Orthopedist',
    'Neurologist',
    'Gynecologist',
    'Ophthalmologist',
    'ENT Specialist',
    'Dentist',
    'Psychiatrist',
    'Urologist',
    'Oncologist',
    'Endocrinologist',
    'Gastroenterologist',
  ];

  // Predefined appointment types
  static const List<String> _appointmentTypes = [
    'Regular Checkup',
    'Follow-up',
    'Consultation',
    'Emergency',
    'Vaccination',
    'Lab Test',
    'Procedure',
    'Surgery',
    'Therapy Session',
  ];

  // Cached static decorations
  static final _sheetDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
  );

  static final _handleDecoration = BoxDecoration(
    color: AppColors.gray300,
    borderRadius: BorderRadius.circular(2),
  );

  static final _closeButtonDecoration = BoxDecoration(
    color: AppColors.gray100,
    borderRadius: BorderRadius.circular(10),
  );

  @override
  void initState() {
    super.initState();
    _doctorNameController = TextEditingController(
      text: widget.appointment?.doctorName,
    );
    _clinicNameController = TextEditingController(
      text: widget.appointment?.clinicName,
    );
    _selectedDate =
        widget.appointment?.date ?? DateTime.now().add(const Duration(days: 1));
    _selectedSpecialty = widget.appointment?.specialty ?? _specialties.first;
    _selectedType = widget.appointment?.type ?? _appointmentTypes.first;
    _selectedStatus = widget.appointment?.status ?? AppointmentStatus.pending;

    // Parse time from string or use default
    if (widget.appointment != null) {
      final timeParts = widget.appointment!.time.split(':');
      final hour =
          int.tryParse(timeParts[0].replaceAll(RegExp(r'[^0-9]'), '')) ?? 9;
      final minute =
          int.tryParse(
            timeParts.length > 1
                ? timeParts[1].replaceAll(RegExp(r'[^0-9]'), '')
                : '0',
          ) ??
          0;
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
    } else {
      _selectedTime = const TimeOfDay(hour: 9, minute: 0);
    }
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _clinicNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _sheetDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDoctorNameField(),
                    const SizedBox(height: 16),
                    _buildClinicNameField(),
                    const SizedBox(height: 16),
                    _buildSpecialtyDropdown(),
                    const SizedBox(height: 16),
                    _buildAppointmentTypeDropdown(),
                    const SizedBox(height: 24),
                    _buildDateTimePickers(),
                    const SizedBox(height: 24),
                    if (isEditing) ...[
                      _buildStatusDropdown(),
                      const SizedBox(height: 24),
                    ],
                    _buildSaveButton(),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: _handleDecoration,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Appointment' : 'Book Appointment',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isEditing
                    ? 'Update appointment details'
                    : 'Schedule your visit with a doctor',
                style: const TextStyle(fontSize: 14, color: AppColors.gray600),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: _closeButtonDecoration,
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.gray700,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorNameField() {
    return CustomTextField(
      controller: _doctorNameController,
      label: 'Doctor Name',
      hint: 'e.g., Dr. John Smith',
      prefixIcon: Icons.person_outlined,
      required: true,
      validator: FieldValidators.required,
    );
  }

  Widget _buildClinicNameField() {
    return CustomTextField(
      controller: _clinicNameController,
      label: 'Clinic / Hospital',
      hint: 'e.g., City Medical Center',
      prefixIcon: Icons.local_hospital_outlined,
      required: true,
      validator: FieldValidators.required,
    );
  }

  Widget _buildSpecialtyDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 18,
              color: AppColors.medicalBlue,
            ),
            const SizedBox(width: 8),
            const Text(
              'Specialty',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Text(' *', style: TextStyle(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray200),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedSpecialty,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
            items: _specialties.map((specialty) {
              return DropdownMenuItem(value: specialty, child: Text(specialty));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedSpecialty = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.category_outlined,
              size: 18,
              color: AppColors.medicalBlue,
            ),
            const SizedBox(width: 8),
            const Text(
              'Appointment Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Text(' *', style: TextStyle(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray200),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
            items: _appointmentTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedType = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.schedule_outlined,
              size: 18,
              color: AppColors.medicalBlue,
            ),
            const SizedBox(width: 8),
            const Text(
              'Date & Time',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Text(' *', style: TextStyle(color: AppColors.error)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildDatePicker()),
            const SizedBox(width: 12),
            Expanded(child: _buildTimePicker()),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: AppColors.medicalBlue,
            ),
            const SizedBox(width: 10),
            Text(
              _formatDate(_selectedDate),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: _selectTime,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time_outlined,
              size: 20,
              color: AppColors.medicalBlue,
            ),
            const SizedBox(width: 10),
            Text(
              _formatTime(_selectedTime),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, size: 18, color: AppColors.medicalBlue),
            const SizedBox(width: 8),
            const Text(
              'Status',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray200),
          ),
          child: DropdownButtonFormField<AppointmentStatus>(
            value: _selectedStatus,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
            items: AppointmentStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(_getStatusLabel(status)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedStatus = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _saveAppointment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.medicalBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isEditing ? Icons.save_rounded : Icons.calendar_month_rounded,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              isEditing ? 'Update Appointment' : 'Book Appointment',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.medicalBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.medicalBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return AppColors.success;
      case AppointmentStatus.pending:
        return AppColors.warning;
      case AppointmentStatus.completed:
        return AppColors.medicalBlue;
      case AppointmentStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getStatusLabel(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final appointment = AppointmentModel(
        id: widget.appointment?.id,
        patientId: widget.appointment?.patientId ?? 1,
        doctorName: _doctorNameController.text.trim(),
        specialty: _selectedSpecialty,
        clinicName: _clinicNameController.text.trim(),
        date: _selectedDate,
        time: _formatTime(_selectedTime),
        status: _selectedStatus,
        type: _selectedType,
        createdAt: widget.appointment?.createdAt ?? now,
        updatedAt: now,
      );
      widget.onSave(appointment);
      Navigator.pop(context);
    }
  }
}
