import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_cubit.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_state.dart';

// ! Custom Network iSSue showing
Widget buildCustomNetworkIssue(
  Responsive r,
  QuranHomeState state,
  BuildContext context,
) {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(r.w * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 64, color: AppColors.grey500),
          SizedBox(height: 16),
          Text(state.errors, textAlign: TextAlign.center),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<QuranHomeCubit>().init(),
            child: Text('Retry'),
          ),
        ],
      ),
    ),
  );
}
