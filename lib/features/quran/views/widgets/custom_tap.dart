// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_cubit.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_state.dart';

// ! =========(ANOTHER SOMETHING) ========
class Tabs extends StatelessWidget {
  final QuranHomeState state;
  const Tabs({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuranHomeCubit>();

    Widget tab(String label, int index) {
      final selected = state.currentTabIndex == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => cubit.changeTab(index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryGreen
                  : AppColors.grey500.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab('Surahs', 0),
        const SizedBox(width: 8),
        tab('Juz', 1),
        const SizedBox(width: 8),
        tab('Bookmarks', 2),
      ],
    );
  }
}
