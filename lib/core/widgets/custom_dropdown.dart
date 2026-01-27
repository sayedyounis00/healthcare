import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<T> items;
  final String Function(T)?
  itemLabel; // Optional: Convert item to display string
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;
  final bool required;
  final bool enabled;

  const CustomDropdown({
    super.key,
    required this.label,
    this.hint,
    this.value,
    required this.items,
    this.itemLabel,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.required = false,
    this.enabled = true,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  Color _getBorderColor() {
    if (!widget.enabled) return Colors.grey[300]!;
    if (_hasError) return const Color(0xFFE53935);
    if (_isFocused) return const Color(0x262196F3);
    return Colors.grey[300]!;
  }

  Color _getLabelColor() {
    if (!widget.enabled) return Colors.grey[400]!;
    if (_hasError) return const Color(0xFFE53935);
    if (_isFocused) return const Color(0xFF2196F3);
    return Colors.grey[600]!;
  }

  String _getItemLabel(T item) {
    if (widget.itemLabel != null) {
      return widget.itemLabel!(item);
    }
    return item.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8, left: 4),
            child: Row(
              children: [
                Text(
                  widget.label,
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
              ],
            ),
          ),

          // Dropdown Field
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: const Color(0x262196F3),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: DropdownButtonFormField<T>(
              initialValue: widget.value,
              items: widget.items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(_getItemLabel(item)),
                    ),
                  )
                  .toList(),
              onChanged: widget.enabled ? widget.onChanged : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: widget.enabled
                    ? (_isFocused ? const Color(0xFFF5F9FF) : Colors.grey[50])
                    : Colors.grey[100],
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        color: _isFocused
                            ? const Color(0xFF2196F3)
                            : Colors.grey[400],
                        size: 22,
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _getBorderColor(), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2196F3),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE53935),
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE53935),
                    width: 2,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              validator: (value) {
                final error = widget.validator?.call(value);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _hasError = error != null;
                      _errorText = error;
                    });
                  }
                });
                return error;
              },
              onTap: () {
                setState(() {
                  _isFocused = true;
                });
              },
              style: TextStyle(
                fontSize: 16,
                color: widget.enabled ? Colors.black87 : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              dropdownColor: Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _isFocused ? const Color(0xFF2196F3) : Colors.grey[400],
              ),
            ),
          ),

          // Error Text
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Row(
                children: [
                  if (_hasError)
                    const Icon(
                      Icons.error_outline,
                      size: 14,
                      color: Color(0xFFE53935),
                    ),
                  if (_hasError) const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _errorText ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
