// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/home/views/widgets/carousel_image_widget.dart';

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
            icon: Icon(CupertinoIcons.location_solid, color: onBackgroundColor),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.arrow_2_circlepath,
              color: onBackgroundColor,
            ),
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
                  SizedBox(height: 20),
                  // ! Search Form Field
                  Container(
                    decoration: BoxDecoration(
                      color: mode == Brightness.dark
                          ? AppColors.black.withOpacity(0.9)
                          : Colors.white,
                      borderRadius: mode == Brightness.light
                          ? BorderRadius.circular(25)
                          : BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Quran, Videos...',
                          hintStyle: textThem.bodyMedium?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                          suffix: Icon(
                            CupertinoIcons.search,
                            color: Colors.grey.shade600,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: r.w * 0.02),
                  Text(
                    'Categories',
                    style: textThem.bodyLarge?.copyWith(
                      color: onBackgroundColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: r.hLarge),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.65,
                        ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final item = categories[index];
                      return CategoryItemsCircle(
                        icon: item.icon,
                        label: item.label,
                        isSoon: item.isSoon,
                        onTap: () {},
                        r: r,
                        textTheme: textThem,
                      );
                    },
                  ),

                  SizedBox(height: r.hLarge),

                  // ! Coming Soon Section
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final img = imageUrls[index];
                      return Container(
                        width: double.infinity,
                        height: r.w * 0.4,
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow,
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                              AppColors.lighblackBg,
                              BlendMode.overlay,
                            ),
                            image: AssetImage(img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: r.hLarge),
                    itemCount: imageUrls.length,
                  ),
                ],
              ),
            ),

            SizedBox(height: r.w * 0.1),
          ],
        ),
      ),
    );
  }
}

// ! ++++=============

class CategoryItem {
  final IconData icon;
  final String label;
  final bool isSoon;
  const CategoryItem({
    required this.icon,
    required this.label,
    this.isSoon = false,
  });
}

const categories = [
  CategoryItem(icon: CupertinoIcons.book, label: 'Quran'),
  CategoryItem(icon: CupertinoIcons.news, label: 'News'),
  CategoryItem(icon: CupertinoIcons.play_circle, label: 'Videos'),
  CategoryItem(icon: CupertinoIcons.checkmark_alt, label: 'Dhikr Counter'),
  CategoryItem(icon: CupertinoIcons.scope, label: 'Discover'),
  CategoryItem(icon: CupertinoIcons.location_north, label: 'Qibla'),
  CategoryItem(icon: CupertinoIcons.time, label: 'Prayer Times'),
  CategoryItem(
    icon: CupertinoIcons.book_solid,
    label: 'Kitab & Library',
    isSoon: true,
  ),
  CategoryItem(icon: CupertinoIcons.calendar, label: 'Calendar & Events'),
  CategoryItem(
    icon: CupertinoIcons.building_2_fill,
    label: 'Madrasa & Tuitions',
    isSoon: true,
  ),
  CategoryItem(icon: CupertinoIcons.person_2, label: 'Islamic Forum'),
  CategoryItem(
    icon: CupertinoIcons.checkmark_rectangle,
    label: 'Qatham Planner',
  ),
  CategoryItem(
    icon: CupertinoIcons.speaker,
    label: 'Dhikr & Dua',
    isSoon: true,
  ),

  CategoryItem(icon: CupertinoIcons.person_alt, label: 'Islamic Jobs'),
  CategoryItem(
    icon: CupertinoIcons.hand_raised,
    label: 'Masjid & Prayer Halls',
  ),
  CategoryItem(
    icon: CupertinoIcons.moon_stars,
    label: 'Moulid & Swalath',
    isSoon: true,
  ),
  CategoryItem(icon: CupertinoIcons.person, label: 'Namaz & Qadah'),
  CategoryItem(icon: CupertinoIcons.list_bullet, label: 'To-Do List'),
  CategoryItem(icon: Icons.calculate, label: 'Zakath Calculator', isSoon: true),
  CategoryItem(icon: CupertinoIcons.moon_stars, label: 'Ramzan & Qadah'),
  CategoryItem(
    icon: CupertinoIcons.person_2,
    label: 'Manage Organization',
    isSoon: true,
  ),
  CategoryItem(
    icon: CupertinoIcons.phone_badge_plus,
    label: 'Ask Ustad',
    isSoon: true,
  ),
  CategoryItem(
    icon: CupertinoIcons.search,
    label: 'Explore Hadees',
    isSoon: true,
  ),
  CategoryItem(icon: CupertinoIcons.cart, label: 'Shopping', isSoon: true),
];

// !=======()=======

class CategoryItemsCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSoon;
  final VoidCallback onTap;
  final Responsive r;
  final TextTheme textTheme;

  const CategoryItemsCircle({
    super.key,
    required this.icon,
    required this.label,
    required this.isSoon,
    required this.onTap,
    required this.r,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: r.w * 0.08,
                backgroundColor: AppColors.accentYellow,
                child: Icon(
                  icon,
                  color: AppColors.primaryGreen,
                  size: r.w * 0.06,
                ),
              ),

              // "Soon" badge
              if (isSoon)
                Positioned(
                  top: -6,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Soon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: r.hSmall * 0.6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ! ======== Footr Cards Section
const imageUrls = [
  'assets/WhatsApp Image 2025-12-18 at 3.15.40 PM.jpeg',
  'assets/WhatsApp Image 2025-12-18 at 3.33.27 PM.jpeg',
];
