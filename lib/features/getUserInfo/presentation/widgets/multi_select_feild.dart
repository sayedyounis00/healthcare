import 'package:flutter/material.dart';
import 'package:healthcare/features/getUserInfo/data/models/chronic_conditions.dart';

class ConditionsMultiSelect extends StatefulWidget {
  final List<Conditions> medicalConditions;
  final List<String> initialSelected;
  final Function(List<String>) onChanged;
  final bool required;
  final String? Function(List<String>?)? validator;

  const ConditionsMultiSelect({
    super.key,
    this.initialSelected = const [],
    required this.onChanged,
    this.required = false,
    this.validator,
    required this.medicalConditions,
  });

  @override
  State<ConditionsMultiSelect> createState() => _ConditionsMultiSelectState();
}

class _ConditionsMultiSelectState extends State<ConditionsMultiSelect> {
  late List<String> _selectedConditions;
  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedConditions = List.from(widget.initialSelected);
  }

  void _toggleCondition(String conditionId) {
    setState(() {
      if (_selectedConditions.contains(conditionId)) {
        _selectedConditions.remove(conditionId);
      } else {
        _selectedConditions.add(conditionId);
      }

      widget.onChanged(_selectedConditions);
    });
  }

  Color _getBorderColor() {
    if (_errorText != null) return const Color(0xFFE53935);
    if (_isFocused) return const Color(0xFF2196F3);
    return Colors.grey[300]!;
  }

  Color _getLabelColor() {
    if (_errorText != null) return const Color(0xFFE53935);
    if (_isFocused) return const Color(0xFF2196F3);
    return Colors.grey[600]!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              'Chronic Conditions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getLabelColor(),
              ),
            ),
            if (widget.required)
              const Text(
                ' *',
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const Spacer(),
          ],
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isFocused = true;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getBorderColor(),
                width: _isFocused ? 2 : 1.5,
              ),
              color: Colors.grey[50],
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: const Color(0xFF2196F3),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(11),
                      topRight: Radius.circular(11),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: widget.medicalConditions.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey[200],
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, index) {
                    final condition = widget.medicalConditions[index];
                    final isSelected = _selectedConditions.contains(
                      condition.id,
                    );
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _toggleCondition(condition.id),
                        borderRadius:
                            index == widget.medicalConditions.length - 1
                            ? const BorderRadius.only(
                                bottomLeft: Radius.circular(11),
                                bottomRight: Radius.circular(11),
                              )
                            : BorderRadius.zero,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color.fromARGB(255, 242, 245, 247)
                                : Colors.white,
                          ),
                          child: Row(
                            children: [
                              // Icon
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color.fromARGB(255, 242, 245, 247)
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  condition.icon,
                                  size: 20,
                                  color: isSelected
                                      ? const Color(0xFF2196F3)
                                      : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  condition.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.black87
                                        : Colors.grey[700],
                                  ),
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2196F3)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF2196F3)
                                        : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
