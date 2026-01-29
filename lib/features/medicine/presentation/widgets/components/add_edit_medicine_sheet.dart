import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';
import 'package:healthcare/core/widgets/text_form_feild.dart';
import 'package:healthcare/features/medicine/data/models/medicine_model.dart'
    as medicine_model;
import 'package:healthcare/features/medicine/presentation/widgets/components/medicine_tag_chip.dart';
import 'package:healthcare/features/medicine/presentation/widgets/components/time_slot_picker.dart';

/// Bottom sheet for adding or editing medicine
class AddEditMedicineSheet extends StatefulWidget {
  final medicine_model.MedicineModel? medicine;
  final void Function(medicine_model.MedicineModel medicine) onSave;

  const AddEditMedicineSheet({super.key, this.medicine, required this.onSave});

  @override
  State<AddEditMedicineSheet> createState() => _AddEditMedicineSheetState();
}

class _AddEditMedicineSheetState extends State<AddEditMedicineSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late List<TimeOfDay> _selectedTimes;
  late List<String> _selectedTags;
  final _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.medicine != null;

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

  static final _selectedTagsDecoration = BoxDecoration(
    color: AppColors.successLight,
    borderRadius: BorderRadius.circular(10),
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine?.drugName);
    _descriptionController = TextEditingController(
      text: widget.medicine?.description,
    );
    // Convert our custom TimeOfDay to Flutter's TimeOfDay for the picker
    _selectedTimes =
        widget.medicine?.timesToTake
            .map((t) => TimeOfDay(hour: t.hour, minute: t.minute))
            .toList() ??
        [];
    _selectedTags = List<String>.from(widget.medicine?.tags ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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
                    _buildDrugNameField(),
                    const SizedBox(height: 16),
                    _buildDescriptionField(),
                    const SizedBox(height: 24),
                    TimeSlotPicker(
                      selectedTimes: _selectedTimes,
                      onTimesChanged: (times) {
                        setState(() {
                          _selectedTimes = times;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildTagsSection(),
                    const SizedBox(height: 32),
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
                isEditing ? 'Edit Medicine' : 'Add New Medicine',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isEditing
                    ? 'Update medication details'
                    : 'Enter medication details below',
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

  Widget _buildDrugNameField() {
    return CustomTextField(
      controller: _nameController,
      label: 'Medicine Name',
      hint: 'e.g., Aspirin, Ibuprofen',
      prefixIcon: Icons.medication_rounded,
      required: true,
      validator: FieldValidators.required,
    );
  }

  Widget _buildDescriptionField() {
    return CustomTextField(
      controller: _descriptionController,
      label: 'Description',
      hint: 'Add dosage, instructions, or notes',
      prefixIcon: Icons.description_outlined,
      maxLines: 3,
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.label_rounded,
              size: 18,
              color: AppColors.medicalBlue,
            ),
            const SizedBox(width: 8),
            const Text(
              'Tags',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Text(
              '${_selectedTags.length} selected',
              style: const TextStyle(fontSize: 12, color: AppColors.gray500),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: medicine_model.MedicineTags.predefined.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return MedicineTagChip(
              tag: tag,
              isSelected: isSelected,
              onTap: () => _toggleTag(tag),
            );
          }).toList(),
        ),
        if (_selectedTags.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: _selectedTagsDecoration,
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 18,
                  color: AppColors.successDark,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Selected: ${_selectedTags.join(", ")}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.successDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _saveMedicine,
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
            Icon(isEditing ? Icons.save_rounded : Icons.add_rounded, size: 22),
            const SizedBox(width: 10),
            Text(
              isEditing ? 'Update Medicine' : 'Add Medicine',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _saveMedicine() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      // Convert Flutter's TimeOfDay to our custom TimeOfDay when saving
      // id is null for new medicines (auto-generated by database)
      final medicine = medicine_model.MedicineModel(
        id: widget.medicine?.id, // null for new, existing id for update
        patientId: widget.medicine?.patientId ?? 1, // FK to patient_data.id
        drugName: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        timesToTake: _selectedTimes
            .map(
              (t) => medicine_model.TimeOfDay(hour: t.hour, minute: t.minute),
            )
            .toList(),
        tags: _selectedTags,
        isActive: true,
        createdAt: widget.medicine?.createdAt ?? now,
        updatedAt: now,
      );
      widget.onSave(medicine);
      Navigator.pop(context);
    }
  }
}
