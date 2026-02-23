import 'package:flutter/material.dart';
import '../colors.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final VoidCallback? onTap;
  final bool showBorder;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 40,
    this.onTap,
    this.showBorder = false,
  });

  String get initials {
    return name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: imageUrl == null
              ? LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: showBorder
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageUrl == null
            ? Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: size * 0.35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}