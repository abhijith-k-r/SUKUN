// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_bloc.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_event.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_state.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    final mode = Theme.of(context).brightness;
    return BlocBuilder<NavbarBloc, NavbarState>(
      builder: (context, state) {
        return StylishBottomBar(
          backgroundColor: mode == Brightness.dark
              ? AppColors.darkBg
              : AppColors.white,
          option: DotBarOptions(
            dotStyle: DotStyle.tile,
            gradient: LinearGradient(
              colors: [AppColors.accentYellow, AppColors.accentYellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          items: [
            BottomBarItem(
              icon: const Icon(Icons.home_filled),
              title: const Text('Home'),
              backgroundColor: onBackgroundColor,
              selectedIcon: const Icon(Icons.read_more),
            ),
            BottomBarItem(
              icon: const Icon(CupertinoIcons.news_solid),
              title: const Text('News'),
              backgroundColor: onBackgroundColor,
            ),
            BottomBarItem(
              icon: const Icon(CupertinoIcons.videocam_circle),
              title: const Text('Videos'),
              backgroundColor: onBackgroundColor,
            ),

            BottomBarItem(
              icon: const Icon(Icons.featured_play_list_outlined),
              title: const Text('Features'),
              backgroundColor: onBackgroundColor,
            ),

            BottomBarItem(
              icon: const Icon(CupertinoIcons.phone),
              title: const Text('Contact'),
              backgroundColor: onBackgroundColor,
            ),
          ],
          hasNotch: true,
          currentIndex: state.selectedIndex,
          onTap: (index) {
            context.read<NavbarBloc>().add(NavigationTabChanged(index));
          },
        );
      },
    );
  }
}
