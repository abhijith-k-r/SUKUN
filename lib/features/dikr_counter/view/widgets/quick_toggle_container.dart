import 'package:flutter/material.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/dikr_counter/view/widgets/build_toggle.dart';

Widget qiuckToggleContainer(
  bool mode,
  bool targetEnabled,
  void Function() onToggleTarget,
  bool hapticEnabled,
  void Function() onToggleHaptic,
  bool isStopwatchActive,
  void Function() onToggleStopwatch,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: mode ? AppColors.black : AppColors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildToggle('Target', targetEnabled, onToggleTarget),
        Container(width: 1, height: 32, color: AppColors.grey500),
        buildToggle('Haptic', hapticEnabled, onToggleHaptic),
        Container(width: 1, height: 32, color: AppColors.grey500),
        buildToggle('Stopwatch', isStopwatchActive, onToggleStopwatch),
      ],
    ),
  );
}
