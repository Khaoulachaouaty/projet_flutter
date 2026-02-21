import 'package:flutter/material.dart';
import '../../colors.dart';

class RememberMeRow extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onForgotPassword;

  const RememberMeRow({
    super.key,
    this.onChanged,
    this.onForgotPassword,
  });

  @override
  State<RememberMeRow> createState() => _RememberMeRowState();
}

class _RememberMeRowState extends State<RememberMeRow> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: widget.onForgotPassword,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Mot de passe oublié ?',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}