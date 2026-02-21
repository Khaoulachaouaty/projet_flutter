import 'package:flutter/material.dart';
import '../../colors.dart';

class AuthTextField extends StatefulWidget {
  final IconData icon;
  final String hint;
  final String? label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onSubmitted;

  const AuthTextField({
    super.key,
    required this.icon,
    required this.hint,
    this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onSubmitted,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _isFocused = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isFocused ? AppColors.grey100 : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hasError
                  ? AppColors.error
                  : _isFocused
                      ? AppColors.primary
                      : AppColors.grey200,
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: _isFocused ? [AppShadows.small] : null,
          ),
          child: Focus(
            onFocusChange: (hasFocus) {
              setState(() => _isFocused = hasFocus);
              if (!hasFocus && widget.validator != null) {
                setState(() {
                  _hasError = widget.validator!(widget.controller.text) != null;
                });
              }
            },
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              onSubmitted: (_) => widget.onSubmitted?.call(),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                prefixIcon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isFocused
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.grey100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 20,
                    color: _isFocused ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 56,
                  minHeight: 48,
                ),
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
        if (_hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              widget.validator!(widget.controller.text) ?? '',
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}