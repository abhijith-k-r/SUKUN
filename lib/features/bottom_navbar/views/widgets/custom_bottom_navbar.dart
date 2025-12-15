// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/bottom_navbar/model/items_model.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_bloc.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_event.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_state.dart';
import 'package:sukun/features/bottom_navbar/views/widgets/bottom_items.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      NavItem(icon: Icons.home_filled, label: 'Home'),
      NavItem(icon: CupertinoIcons.book, label: 'Quran'),
      NavItem(icon: CupertinoIcons.news, label: 'News'),
      NavItem(icon: CupertinoIcons.square_list, label: 'Todo'),
      NavItem(icon: CupertinoIcons.person, label: 'Account'),
    ];

    // final mode = Theme.of(context).brightness;
    final r = Responsive(context);

    const primaryColor = AppColors.accentYellow;

    return BlocBuilder<NavbarBloc, NavbarState>(
      builder: (context, state) {
        final selectedIndex = state.selectedIndex;
        final width = MediaQuery.of(context).size.width;
        final itemWidth = width / items.length;
        final circleCenterX = itemWidth * selectedIndex + itemWidth / 2;

        return SizedBox(
          // color: outerBg,
          height: r.w * 0.25,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bar background
              Positioned.fill(
                top: 18,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    // mode == Brightness.dark
                    //     ? AppColors.black
                    //     : AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(items.length, (index) {
                      final item = items[index];
                      final isSelected = index == selectedIndex;

                      // If selected: hide icon inside the bar (circle will show it)
                      if (isSelected) {
                        return SizedBox(width: itemWidth * 0.6);
                      }

                      return BottomItem(
                        icon: item.icon,
                        label: item.label,
                        isSelected: false,
                        primaryColor: primaryColor,
                        onTap: () {
                          context.read<NavbarBloc>().add(
                            NavigationTabChanged(index),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),

              // Moving circle above bar
              Positioned(
                top: -8,
                left: circleCenterX - 35, // circle radius
                child: GestureDetector(
                  onTap: () {
                    context.read<NavbarBloc>().add(
                      NavigationTabChanged(selectedIndex),
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[selectedIndex].icon,
                          color: Colors.white,
                          size: 26,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[selectedIndex].label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
