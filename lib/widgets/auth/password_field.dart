import 'package:flutter/material.dart';
import '../../colors.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final VoidCallback? onSubmitted;

  const PasswordField({
    super.key,
    required this.controller,
    this.label,
    this.onSubmitted,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isFocused = false;
  bool _isObscured = true;
  double _strength = 0;

  void _checkStrength(String value) {
    double strength = 0;
    if (value.length >= 8) strength += 0.25;
    if (value.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (value.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;
    
    setState(() => _strength = strength);
  }

  Color get _strengthColor {
    if (_strength <= 0.25) return AppColors.error;
    if (_strength <= 0.5) return AppColors.warning;
    if (_strength <= 0.75) return Colors.orange;
    return AppColors.success;
  }

  String get _strengthText {
    if (_strength <= 0.25) return 'Faible';
    if (_strength <= 0.5) return 'Moyen';
    if (_strength <= 0.75) return 'Bon';
    return 'Excellent';
  }

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
              color: _isFocused ? AppColors.primary : AppColors.grey200,
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: _isFocused ? [AppShadows.small] : null,
          ),
          child: Focus(
            onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
            child: TextField(
              controller: widget.controller,
              obscureText: _isObscured,
              onChanged: _checkStrength,
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
                    Icons.lock_outline,
                    size: 20,
                    color: _isFocused ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 56,
                  minHeight: 48,
                ),
                suffixIcon: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      key: ValueKey(_isObscured),
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                ),
                hintText: 'Mot de passe',
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
        
        // Indicateur de force
        if (widget.controller.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: _strength,
                    backgroundColor: AppColors.grey200,
                    valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _strengthText,
                style: TextStyle(
                  fontSize: 12,
                  color: _strengthColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}