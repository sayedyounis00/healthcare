import 'package:flutter/material.dart';

class TimeChip extends StatelessWidget {
  final String time;

  const TimeChip({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF4FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4A90E2).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 14,
            color: const Color(0xFF4A90E2),
          ),
          const SizedBox(width: 4),
          Text(
            time,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A90E2),
            ),
          ),
        ],
      ),
    );
  }
}