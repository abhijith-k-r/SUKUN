import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/dikr_counter/model/dhikr_model.dart';

class CounterSection extends StatelessWidget {
  final Dhikr? selectedDhikr;
  final int counter;
  final int stopwatchSeconds;
  final bool isStopwatchActive;
  final bool targetEnabled;
  final bool hapticEnabled;
  final VoidCallback onTap;
  final VoidCallback onReset;
  final VoidCallback onSave;
  final VoidCallback onClearSelection;
  final VoidCallback onToggleTarget;
  final VoidCallback onToggleHaptic;
  final VoidCallback onToggleStopwatch;

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
                          color: selectedDhikr!.target == counter
                              ? AppColors.primaryGreen
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
              style: const TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryGreen,
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
                  color: const Color(0xFFF2C238).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer, size: 16, color: Color(0xFFF2C238)),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(stopwatchSeconds),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF2C238),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 32),

        // Main Tap Button
        GestureDetector(
          onTap: () {
            if (hapticEnabled) {
              HapticFeedback.lightImpact();
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
                Icon(Icons.touch_app, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'TAP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Action Controls
        Row(
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
                onPressed: onSave,
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
        ),

        const SizedBox(height: 24),

        // Quick Toggles
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: mode ? AppColors.black : AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildToggle('Target', targetEnabled, onToggleTarget),
              Container(width: 1, height: 32, color: Colors.grey[200]),
              _buildToggle('Haptic', hapticEnabled, onToggleHaptic),
              Container(width: 1, height: 32, color: Colors.grey[200]),
              _buildToggle('Stopwatch', isStopwatchActive, onToggleStopwatch),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(String label, bool isEnabled, VoidCallback onToggle) {
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
              alignment: isEnabled
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
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
}
