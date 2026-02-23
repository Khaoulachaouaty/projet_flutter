import 'package:flutter/material.dart';
import '../../colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final String hint;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onFilterTap,
    this.hint = 'Rechercher...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.search, color: AppColors.textSecondary),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(color: AppColors.textHint),
              ),
            ),
          ),
          if (onFilterTap != null)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onFilterTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.tune,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}