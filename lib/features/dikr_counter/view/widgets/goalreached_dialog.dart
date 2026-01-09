import 'package:flutter/material.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/dikr_counter/model/dhikr_model.dart';

void showGoalReachedDialog(BuildContext context, Dhikr? selectedDhikr) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 28),
          const SizedBox(width: 12),
          const Text(
            '🎉 Goal Reached!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(
        'You completed ${selectedDhikr!.nameArabic}\n${selectedDhikr.target} times!',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Great!'),
        ),
      ],
    ),
  );
}
