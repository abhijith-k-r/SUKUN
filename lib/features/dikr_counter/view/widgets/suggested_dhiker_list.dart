// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/dikr_counter/model/dhikr_model.dart';

class SuggestedDhikrList extends StatelessWidget {
  final List<Dhikr> dhikrs;
  final Dhikr? selectedDhikr;
  final Function(Dhikr) onDhikrSelected;

  const SuggestedDhikrList({
    super.key,
    required this.dhikrs,
    required this.onDhikrSelected,
    this.selectedDhikr,
  });

  @override
  Widget build(BuildContext context) {
    final textThem = Theme.of(context).textTheme;
    final r = Responsive(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Dhikr',
          style: textThem.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: r.w * 0.35,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: dhikrs.length + 1,
            itemBuilder: (context, index) {
              if (index == dhikrs.length) {
                return _buildAddCustomCard();
              }
              return _buildDhikrCard(context, dhikrs[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDhikrCard(BuildContext context, Dhikr dhikr) {
    final textThem = Theme.of(context).textTheme;

    final mode = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedDhikr?.id == dhikr.id;

    return GestureDetector(
      onTap: () => onDhikrSelected(dhikr),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGreen
              : mode
              ? AppColors.black
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey500),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Target: ${dhikr.target}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 8),

              Text(
                dhikr.nameArabic,
                style: textThem.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                dhikr.nameEnglish,
                style: textThem.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: mode ? AppColors.white : AppColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSelected ? Icons.play_arrow : Icons.pause,
                    size: 18,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCustomCard() {
    return Container(
      width: 144,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 24, color: Color(0xFF098b59)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Custom Dhikr',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
