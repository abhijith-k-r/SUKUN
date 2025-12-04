// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';

class PopularNews extends StatelessWidget {
  const PopularNews({super.key});

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.w * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: r.w * 0.02),
              Text(
                'Popular News',
                style: textThem.bodyLarge?.copyWith(
                  color: onBackgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // crossAxisSpacing: 2,
                  childAspectRatio: 0.885,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: mode == Brightness.dark
                          ? AppColors.white
                          : AppColors.grey500,
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
                                      top: Radius.circular(10),
                                    ),
                                    child: Image.asset(
                                      'assets/news.jpg',
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
                                'New Islamic Art Exhibit Opens in London',
                                style: textThem.bodyMedium?.copyWith(
                                  color: mode == Brightness.dark
                                      ? AppColors.black
                                      : AppColors.white,
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
            ],
          ),
        ),
      ),
    );
  }
}
