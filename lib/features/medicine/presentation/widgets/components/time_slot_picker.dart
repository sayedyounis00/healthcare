import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';

class TimeSlotPicker extends StatelessWidget {
  final List<TimeOfDay> selectedTimes;
  final ValueChanged<List<TimeOfDay>> onTimesChanged;

  const TimeSlotPicker({
    super.key,
    required this.selectedTimes,
    required this.onTimesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: AppColors.medicalBlue,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Times to Take',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            _buildAddTimeButton(context),
          ],
        ),
        const SizedBox(height: 12),
        if (selectedTimes.isEmpty)
          _buildEmptyState()
        else
          _buildTimeSlotsList(context),
      ],
    );
  }

  Widget _buildAddTimeButton(BuildContext context) {
    return Material(
      color: AppColors.medicalBlue.withAlpha(26),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => _showTimePicker(context),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 18, color: AppColors.medicalBlue),
              const SizedBox(width: 4),
              Text(
                'Add Time',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.medicalBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.alarm_add_rounded, size: 40, color: AppColors.gray400),
          const SizedBox(height: 8),
          Text(
            'No times set',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap "Add Time" to schedule medication times',
            style: TextStyle(fontSize: 12, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsList(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: selectedTimes.asMap().entries.map((entry) {
        final index = entry.key;
        final time = entry.value;
        return _TimeSlotChip(
          time: time,
          onRemove: () => _removeTime(index),
          onEdit: () => _editTime(context, index),
        );
      }).toList(),
    );
  }

  Future<void> _showTimePicker(BuildContext context, [int? editIndex]) async {
    final initialTime = editIndex != null
        ? selectedTimes[editIndex]
        : TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.medicalBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final newTimes = List<TimeOfDay>.from(selectedTimes);
      if (editIndex != null) {
        newTimes[editIndex] = picked;
      } else {
        newTimes.add(picked);
      }
      // Sort times
      newTimes.sort((a, b) {
        final aMinutes = a.hour * 60 + a.minute;
        final bMinutes = b.hour * 60 + b.minute;
        return aMinutes.compareTo(bMinutes);
      });
      onTimesChanged(newTimes);
    }
  }

  void _removeTime(int index) {
    final newTimes = List<TimeOfDay>.from(selectedTimes);
    newTimes.removeAt(index);
    onTimesChanged(newTimes);
  }

  void _editTime(BuildContext context, int index) {
    _showTimePicker(context, index);
  }
}

class _TimeSlotChip extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  const _TimeSlotChip({
    required this.time,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.medicalBlue.withAlpha(26),
            AppColors.deepBlue.withAlpha(26),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.medicalBlue.withAlpha(77),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getTimeIcon(time),
                  size: 18,
                  color: AppColors.medicalBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(time),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepBlue,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.error.withAlpha(26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 12,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTimeIcon(TimeOfDay time) {
    if (time.hour >= 5 && time.hour < 12) {
      return Icons.wb_sunny_outlined;
    } else if (time.hour >= 12 && time.hour < 17) {
      return Icons.wb_twilight_outlined;
    } else if (time.hour >= 17 && time.hour < 21) {
      return Icons.nights_stay_outlined;
    } else {
      return Icons.dark_mode_outlined;
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
