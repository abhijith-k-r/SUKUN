import 'package:flutter/material.dart';
import 'package:sukun/core/theme/app_colors.dart';

Widget buildToggle(String label, bool isEnabled, VoidCallback onToggle) {
  return GestureDetector(
    onTap: onToggle,
    child: Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 24,
          decoration: BoxDecoration(
            color: isEnabled ? AppColors.primaryGreen : AppColors.grey500,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
      ],
    ),
  );
}
