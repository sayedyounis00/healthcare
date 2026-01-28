import 'package:flutter/material.dart';
import 'package:healthcare/core/constants/app_colors.dart';

class MedicineTagChip extends StatelessWidget {
  final String tag;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showRemove;
  final VoidCallback? onRemove;

  const MedicineTagChip({
    super.key,
    required this.tag,
    this.isSelected = false,
    this.onTap,
    this.showRemove = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getTagColor(tag);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: showRemove ? 10 : 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withAlpha(26),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : color.withAlpha(128),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getTagIcon(tag),
                size: 14,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 6),
              Text(
                tag.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : color,
                  letterSpacing: 0.5,
                ),
              ),
              if (showRemove) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onRemove,
                  child: Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Get consistent color for each tag type
  Color _getTagColor(String tagName) {
    final tagLower = tagName.toLowerCase();

    switch (tagLower) {
      case 'antibiotics':
        return AppColors.errorDark;
      case 'painkillers':
        return AppColors.warmOrange;
      case 'vitamins':
        return AppColors.healingGreen;
      case 'high-pressure':
        return AppColors.heartRate;
      case 'diabetes':
      case 'sugar':
        return AppColors.glucose;
      case 'heart':
        return AppColors.cardiology;
      case 'allergy':
        return AppColors.medicalPink;
      case 'digestive':
        return AppColors.medicalTeal;
      case 'sleep':
        return AppColors.deepPurple;
      case 'anxiety':
        return AppColors.carePurple;
      default:
        // Generate consistent color based on tag name
        final hash = tagLower.hashCode.abs() % 8;
        final colors = [
          AppColors.medicalBlue,
          AppColors.healingGreen,
          AppColors.medicalTeal,
          AppColors.carePurple,
          AppColors.warmOrange,
          AppColors.medicalPink,
          AppColors.deepBlue,
          AppColors.medicalGreen,
        ];
        return colors[hash];
    }
  }

  /// Get relevant icon for each tag type
  IconData _getTagIcon(String tagName) {
    final tagLower = tagName.toLowerCase();

    switch (tagLower) {
      case 'antibiotics':
        return Icons.bug_report_outlined;
      case 'painkillers':
        return Icons.flash_on_outlined;
      case 'vitamins':
        return Icons.wb_sunny_outlined;
      case 'high-pressure':
        return Icons.speed_outlined;
      case 'diabetes':
      case 'sugar':
        return Icons.water_drop_outlined;
      case 'heart':
        return Icons.favorite_outline;
      case 'allergy':
        return Icons.warning_amber_outlined;
      case 'digestive':
        return Icons.set_meal_outlined;
      case 'sleep':
        return Icons.nightlight_outlined;
      case 'anxiety':
        return Icons.psychology_outlined;
      default:
        return Icons.local_pharmacy_outlined;
    }
  }
}

/// A horizontal scrollable list of tags
class MedicineTagsList extends StatelessWidget {
  final List<String> tags;
  final bool scrollable;

  // Cached static style
  static const _emptyTextStyle = TextStyle(
    fontSize: 12,
    color: AppColors.gray500,
    fontStyle: FontStyle.italic,
  );

  const MedicineTagsList({
    super.key,
    required this.tags,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const Text('No tags', style: _emptyTextStyle);
    }

    if (scrollable) {
      // Use ListView.builder for better performance with many tags
      return SizedBox(
        height: 32,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tags.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: MedicineTagChip(tag: tags[index]),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => MedicineTagChip(tag: tag)).toList(),
    );
  }
}
