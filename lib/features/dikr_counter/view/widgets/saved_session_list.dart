import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/dikr_counter/model/dhikr_model.dart';

class SavedSessionsList extends StatelessWidget {
  final List<DhikrSession> sessions;

  const SavedSessionsList({super.key, required this.sessions});

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return 'Today, ${DateFormat('h:mm a').format(timestamp)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${DateFormat('h:mm a').format(timestamp)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sessions.isNotEmpty) const Text('Saved Sessions'),
        const SizedBox(height: 12),
        ...sessions.map((session) => _buildSessionItem(context, session)),
      ],
    );
  }

  Widget _buildSessionItem(BuildContext context, DhikrSession session) {
    final mode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: mode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: session.goalMet
                  ? AppColors.primaryGreen.withOpacity(0.1)
                  : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              session.goalMet ? Icons.check_circle : Icons.history,
              size: 20,
              color: session.goalMet
                  ? AppColors.primaryGreen
                  : Colors.grey[500],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.nameEnglish),
                const SizedBox(height: 2),
                Text(
                  _formatTimestamp(session.timestamp),
                  style: TextStyle(fontSize: 12, color: AppColors.grey500),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                session.count.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: session.goalMet
                      ? AppColors.primaryGreen
                      : AppColors.grey500,
                ),
              ),
              if (session.goalMet) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.star, size: 12, color: AppColors.accentYellow),
                    const SizedBox(width: 2),
                    Text(
                      'Goal Met',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentYellow,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
