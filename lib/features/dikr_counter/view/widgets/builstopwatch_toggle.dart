import 'package:flutter/material.dart';
import 'package:sukun/core/theme/app_colors.dart';

Widget buildStopwatchToggle(
  Function() onToggleStopwatch,
  bool isStopwatchActive,
) {
  return GestureDetector(
    onTap: onToggleStopwatch,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isStopwatchActive ? AppColors.primaryGreen : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accentYellow, width: 2),
      ),
      child: Icon(
        isStopwatchActive ? Icons.pause : Icons.play_arrow,
        size: 16,
        color: AppColors.white,
      ),
    ),
  );
}
