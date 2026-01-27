import 'package:flutter/material.dart';

class ChipList extends StatelessWidget {
  final String label;
  final List<String> items;
  final Color color;
  const ChipList({
    super.key,
    required this.label,
    required this.items,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        items.isEmpty
            ? Text(
                'None',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  fontStyle: FontStyle.italic,
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.shade700),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        color: color.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
}

extension ColorShade on Color {
  Color get shade700 {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();
  }
}
