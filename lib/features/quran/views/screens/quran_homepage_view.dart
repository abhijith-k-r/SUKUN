// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/widgets/custom_newtworkissue_widget.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_cubit.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_state.dart';
import 'package:sukun/features/quran/views/widgets/custom_tap.dart';
import 'package:sukun/features/quran/views/widgets/quickaccess_chip_widget.dart';
import 'package:sukun/features/quran/views/widgets/recentlyread_card_widget.dart';
import 'package:sukun/features/quran/views/widgets/tab_contents_widget.dart';

class QuranHomePage extends StatelessWidget {
  const QuranHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return BlocBuilder<QuranHomeCubit, QuranHomeState>(
      builder: (context, state) {
        debugPrint('QuranHomePage State: $state');
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.errors.isNotEmpty || state is QuranHomeError) {
          return buildCustomNetworkIssue(r, state, context);
        }

        // if (state is QuranHomeLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: Image.asset(
                'assets/sukun_logo.png',
                width: r.fieldWidth * 0.4,
              ),
              actions: [
                Icon(Icons.language),
                SizedBox(width: r.wSmall),
                Icon(Icons.gps_fixed_rounded),
                SizedBox(width: r.wSmall),
                Icon(Icons.notifications_none),
                SizedBox(width: r.wSmall),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: r.w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RecentlyReadCard(progress: state.lastReading),
                  const SizedBox(height: 24),
                  QuickAccessChips(),
                  const SizedBox(height: 16),
                  Tabs(state: state),
                  const SizedBox(height: 8),
                  TabContent(state: state),
                ],
              ),
            ),
          );
        // }
        // return const SizedBox();
      },
    );
  }
}
