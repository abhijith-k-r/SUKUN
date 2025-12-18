// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';

// ! Carousal Image
class CarousalImagesState extends StatefulWidget {
  const CarousalImagesState({super.key});

  @override
  State<CarousalImagesState> createState() => _CarousalImagesStateState();
}

class _CarousalImagesStateState extends State<CarousalImagesState> {
  int currentIndex = 0;
  // Move HERE - class level state variable
  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textTheme = Theme.of(context).textTheme;
    final mode = Theme.of(context).brightness;

    // Clamp text scaling to prevent overflow (max 1.3x)
    final textScaler = MediaQuery.textScalerOf(context).clamp();

    return Container(
      width: double.infinity,
      height: r.w * 0.6,
      color: mode == Brightness.dark
          ? AppColors.lighblackBg
          : AppColors.lightBg,
      child: Stack(
        children: [
          // Carousel
          CarouselSlider.builder(
            itemCount: 2,
            itemBuilder: (context, index, realIndex) {
              return SizedBox(
                width: double.infinity,
                height: r.w * 0.6, // Match container height
                child: Image.asset(
                  index == 0
                      ? 'assets/carosal-img-1.png'
                      : 'assets/carousal_image_2.png',
                  fit: BoxFit.cover,
                ),
              );
            },
            options: CarouselOptions(
              height: r.w * 0.6,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              onPageChanged: (index, reason) =>
                  setState(() => currentIndex = index),
            ),
          ),

          // Responsive overlay content
          Positioned(
            top: 12,
            left: 20,
            right: 20,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  // Scroll if text overflows
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FittedBox(
                          // Auto-scale headline
                          child: Text(
                            'Find Your Tranquility\nwith SUKUN',
                            style: textTheme.headlineLarge?.copyWith(
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: textScaler.scale(8)),
                        Flexible(
                          // Flexible subtitle
                          child: Text(
                            'Your daily companion for an Islamic lifestyle.\nLearn, discover, and grow in your faith.',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: textScaler.scale(12)),
                        // Buttons Row - Fixed height
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildButton(
                              label: 'Asar 12:45pm',
                              bgColor: currentIndex == 0
                                  ? AppColors.accentYellow
                                  : AppColors.primaryGreen,
                              fgColor: currentIndex == 0
                                  ? AppColors.black
                                  : AppColors.white,
                              r: r,
                            ),
                            SizedBox(width: 12),
                            _buildButton(
                              label: 'Quran',
                              bgColor: currentIndex == 0
                                  ? AppColors.primaryGreen
                                  : AppColors.accentYellow,
                              fgColor: currentIndex == 0
                                  ? AppColors.white
                                  : AppColors.black,
                              r: r,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          //!  Indicators
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? AppColors.white
                        : AppColors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ! Helper for consistent buttons
  Widget _buildButton({
    required String label,
    required Color bgColor,
    required Color fgColor,
    required Responsive r,
  }) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: EdgeInsets.symmetric(horizontal: r.w * 0.04, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        // Fixed text scaling for buttons
        textStyle: TextStyle(fontSize: 14),
      ),
      child: Text(label),
    );
  }
}
