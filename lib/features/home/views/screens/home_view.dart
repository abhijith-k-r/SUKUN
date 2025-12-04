// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textThem = Theme.of(context).textTheme;
    final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    final mode = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/sukun_logo.png', width: r.fieldWidth * 0.4),
        backgroundColor: mode == Brightness.dark
            ? AppColors.lighblackBg
            : AppColors.lightBg,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.search, color: onBackgroundColor),
          ),

          Icon(CupertinoIcons.bell, color: onBackgroundColor),
          SizedBox(width: r.w * 0.05),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ! Carousal Images
            CarousalImagesState(),
            // ! Categories
            Padding(
              padding: EdgeInsets.symmetric(horizontal: r.w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.w * 0.02),
                  Text(
                    'Categories',
                    style: textThem.bodyLarge?.copyWith(
                      color: onBackgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: r.w * 0.02),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 25,
                      childAspectRatio: 0.885,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: index % 2 != 0
                                ? AppColors.primaryGreen
                                : AppColors.accentYellow,
                            foregroundColor: AppColors.white,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(CupertinoIcons.book),
                            ),
                          ),
                          Text(
                            'Quran',
                            style: textThem.bodyMedium?.copyWith(
                              color: onBackgroundColor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // ! Featuured Videos
            Container(
              width: double.infinity,
              height: r.w * 0.6,
              decoration: BoxDecoration(color: AppColors.primaryGreen),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: r.w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: r.w * 0.02),
                    Text(
                      'Featured Videos',
                      style: textThem.bodyLarge?.copyWith(
                        color: onBackgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: r.w * 0.5,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: SizedBox(
                                width: r.w * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: AlignmentGeometry.center,
                                      children: [
                                        Container(
                                          width: r.w * 0.5,
                                          height: r.w * 0.3,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(15),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(15),
                                            ),
                                            child: Image.asset(
                                              'assets/6512e4f3a9aa647e34d326e6cbd2f44b.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              CupertinoIcons.play_circle,
                                              size: r.w * 0.1,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: EdgeInsets.all(r.w * 0.01),
                                      child: Text(
                                        'The Beauty of \nQuaranic Recitation kdkf lkldjjfds j;sdsjf ',
                                        style: textThem.bodyMedium?.copyWith(
                                          color: onBackgroundColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: r.w * 0.04),
              child: Container(
                width: double.infinity,
                height: r.w * 0.3,
                decoration: BoxDecoration(color: AppColors.accentYellow),
                child: Column(children: []),
              ),
            ),

            SizedBox(height: r.w * 0.1),
          ],
        ),
      ),
    );
  }
}

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

    return Container(
      width: double.infinity,
      height: r.w * 0.7,
      color: mode == Brightness.dark
          ? AppColors.lighblackBg
          : AppColors.lightBg,
      child: Stack(
        children: [
          // ! Carousel
          CarouselSlider.builder(
            itemCount: 2,
            itemBuilder: (context, index, realIndex) {
              return SizedBox(
                width: double.infinity,
                height: r.w * 0.7,
                child: Image.asset(
                  index == 0
                      ? 'assets/carousal_image_1.png'
                      : 'assets/carousal_image_2.png',
                  fit: BoxFit.cover,
                ),
              );
            },
            options: CarouselOptions(
              height: r.w * 0.7,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),

          currentIndex == 0
              ? Positioned(
                  bottom: 25,
                  left: 20,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Your \nTranquility \nwith SUKUN',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: r.hLarge,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: r.w * 0.02),

                        Text(
                          'Your daily companion for an Islamic lifestyle. \nLearn, discover, and grow in your faith.',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.black,
                          ),
                        ),

                        SizedBox(height: r.w * 0.02),

                        // ! Buttons
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentYellow,

                                foregroundColor: AppColors.black,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Start Learning'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                foregroundColor: AppColors.primaryGreen,
                                padding: EdgeInsets.only(
                                  left: r.w * 0.03,
                                  right: r.w * 0.03,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Exploare Resources'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Positioned(
                  bottom: 25,
                  left: 20,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Your \nTranquility \nwith SUKUN',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: r.hLarge,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: r.w * 0.02),

                        Text(
                          'Your daily companion for an Islamic lifestyle. \nLearn, discover, and grow in your faith.',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.white,
                          ),
                        ),

                        SizedBox(height: r.w * 0.02),

                        // ! Buttons
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentYellow,

                                foregroundColor: AppColors.black,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Start Learning'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                foregroundColor: AppColors.primaryGreen,
                                padding: EdgeInsets.only(
                                  left: r.w * 0.03,
                                  right: r.w * 0.03,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Exploare Resources'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

          //! Indicator
          Positioned(
            bottom: 16,
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
}
