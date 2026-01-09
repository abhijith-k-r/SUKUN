// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/dikr_counter/model/dhikr_model.dart';
import 'package:sukun/features/dikr_counter/view/widgets/action_controls.dart';
import 'package:sukun/features/dikr_counter/view/widgets/builstopwatch_toggle.dart';
import 'package:sukun/features/dikr_counter/view/widgets/goalreached_dialog.dart';
import 'package:sukun/features/dikr_counter/view/widgets/quick_toggle_container.dart';

class CounterSection extends StatelessWidget {
  final Dhikr? selectedDhikr;
  final int counter;
  final int stopwatchSeconds;
  final bool isStopwatchActive;
  final bool isTimerRunning;
  final bool targetEnabled;
  final bool hapticEnabled;
  final VoidCallback onTap;
  final VoidCallback onReset;
  final VoidCallback onSave;
  final VoidCallback onClearSelection;
  final VoidCallback onToggleTarget;
  final VoidCallback onToggleHaptic;
  final VoidCallback onToggleStopwatch;
  final VoidCallback onToggleTimer;

  const CounterSection({
    super.key,
    this.selectedDhikr,
    required this.counter,
    required this.stopwatchSeconds,
    required this.isStopwatchActive,
    required this.targetEnabled,
    required this.hapticEnabled,
    required this.onTap,
    required this.onReset,
    required this.onSave,
    required this.onClearSelection,
    required this.onToggleTarget,
    required this.onToggleHaptic,
    required this.onToggleStopwatch,
    required this.onToggleTimer,
    required this.isTimerRunning,
  });

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final textThem = Theme.of(context).textTheme;
    final mode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Selected Dhikr Info
        if (selectedDhikr != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Current Selection',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        '${selectedDhikr!.nameArabic} - ${selectedDhikr!.target}',
                        style: textThem.titleLarge?.copyWith(
                          color: selectedDhikr != null
                              ? (counter == selectedDhikr!.target
                                    ? AppColors.primaryGreen
                                    : (counter > selectedDhikr!.target + 10
                                          ? AppColors.error
                                          : (counter > selectedDhikr!.target
                                                ? AppColors.accentYellow
                                                : null)))
                              : null,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClearSelection,
                  icon: const Icon(Icons.close, size: 20),
                  color: AppColors.grey500,
                  tooltip: 'Clear Selection',
                ),
              ],
            ),
          ),

        // Big Counter Display
        Column(
          children: [
            Text(
              counter.toString(),
              style: TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w800,
                color: selectedDhikr != null
                    ? (counter == selectedDhikr!.target
                          ? AppColors.primaryGreen
                          : (counter > selectedDhikr!.target + 10
                                ? AppColors.error
                                : (counter > selectedDhikr!.target
                                      ? AppColors.accentYellow
                                      : null)))
                    : null,
                height: 1,
              ),
            ),
            if (isStopwatchActive) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildStopwatchToggle(onToggleTimer, isTimerRunning),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.timer,
                      size: 16,
                      color: AppColors.accentYellow,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(stopwatchSeconds),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentYellow,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 32),

        //!  Main Tap Button
        GestureDetector(
          onTap: () {
            if (hapticEnabled) {
              HapticFeedback.selectionClick();
              Future.delayed(const Duration(milliseconds: 50), () {
                HapticFeedback.lightImpact();
              });
            }

            if (targetEnabled &&
                selectedDhikr != null &&
                counter >= selectedDhikr!.target) {
              showGoalReachedDialog(context, selectedDhikr);
              return;
            }

            onTap();
          },
          child: Container(
            width: 192,
            height: 192,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF098b59), Color(0xFF076d45)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF098b59).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: const Color(0xFFEEFDF6), width: 4),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app, size: 48, color: AppColors.white),
                SizedBox(height: 8),
                Text(
                  'TAP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        //!  Action Controls
        actionControls(context, mode, onReset, onSave, counter, selectedDhikr),

        const SizedBox(height: 24),

        // ! Quick Toggles
        qiuckToggleContainer(
          mode,
          targetEnabled,
          onToggleTarget,
          hapticEnabled,
          onToggleHaptic,
          isStopwatchActive,
          onToggleStopwatch,
        ),
      ],
    );
  }
}
