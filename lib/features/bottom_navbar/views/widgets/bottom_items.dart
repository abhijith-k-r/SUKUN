
import 'package:flutter/material.dart';
import 'package:sukun/core/theme/app_colors.dart';

class BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color primaryColor;

  const BottomItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final unselectedColor = AppColors.grey500;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 40, // <= matches the constraint in the error log
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? primaryColor : unselectedColor,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? primaryColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
