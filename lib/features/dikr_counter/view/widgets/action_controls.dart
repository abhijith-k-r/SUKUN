import 'package:flutter/material.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/core/widgets/custom_snackbar_widgets.dart';
import 'package:sukun/features/dikr_counter/model/dhikr_model.dart';

Widget actionControls(
  BuildContext context,
  bool mode,
  void Function() onReset,
  void Function() onSave,
  int counter,
  Dhikr? selectedDhiker,
) {
  return Row(
    children: [
      Expanded(
        child: ElevatedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.restart_alt, size: 20),
          label: const Text('Reset'),
          style: ElevatedButton.styleFrom(
            backgroundColor: mode ? AppColors.black : AppColors.white,
            foregroundColor: mode ? AppColors.white : Colors.grey[700],
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      const SizedBox(width: 16),

      Expanded(
        child: ElevatedButton.icon(
          onPressed: () {
            onSave();
            if (counter == selectedDhiker!.target ||
                counter > selectedDhiker.target) {
              customSnackBar(
                context,
                '🎉 Goal Reached & Saved!',
                Icons.done,
                AppColors.primaryGreen,
              );
            } else {
              customSnackBar(
                context,
                '📊 Progress Saved!',
                Icons.error,
                AppColors.accentYellow,
              );
            }
          },
          icon: const Icon(Icons.save, size: 20),
          label: const Text('Save Progress'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentYellow,
            foregroundColor: AppColors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    ],
  );
}
