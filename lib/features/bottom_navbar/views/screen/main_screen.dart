// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_bloc.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_event.dart';
import 'package:sukun/features/bottom_navbar/views/widgets/custom_bottom_navbar.dart';
import 'package:sukun/features/home/views/screens/home_view.dart';
import 'package:sukun/features/news/views/screens/popular_news.dart';
import 'package:sukun/features/videos/views/screen/featured_videos.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavbarBloc(),
      child: Builder(
        builder: (context) {
          final navigationBloc = context.read<NavbarBloc>();
          final textTheme = Theme.of(context).textTheme;
          final onBackgroundColor = Theme.of(context).colorScheme.onBackground;

          return Scaffold(
            body: PageView(
              controller: navigationBloc.pageController,
              onPageChanged: (index) {
                navigationBloc.add(NavigationTabChanged(index));
              },
              children: [
                HomeView(),
                PopularNews(),
                FeaturedVideos(),

                Scaffold(
                  body: Center(
                    child: Text(
                      'Profile',
                      style: textTheme.bodyMedium?.copyWith(
                        color: onBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: const CustomBottomNavBar(),
          );
        },
      ),
    );
  }
}
