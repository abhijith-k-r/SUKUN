import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';

class BookmarkView extends StatelessWidget {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textThem = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/sukun_logo.png', width: r.fieldWidth * 0.4),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: r.w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: r.hLarge),
            Text(
              'Bookmarks',
              style: textThem.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: r.w * 0.15,
                      height: r.w * 0.2,
                      decoration: BoxDecoration(
                        color: AppColors.accentYellow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/news.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      'Keralathil Kanatha Mazha',
                      style: textThem.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Source: news today',
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Updated: 2 hours before',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.bookmark_fill,
                        color: AppColors.accentYellow,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
