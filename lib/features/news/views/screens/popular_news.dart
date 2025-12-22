// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/news/views/screens/bookmark_view.dart';

class PopularNews extends StatelessWidget {
  const PopularNews({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textThem = Theme.of(context).textTheme;
    final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/sukun_logo.png', width: r.fieldWidth * 0.4),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest News',
                    style: textThem.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  TextButton.icon(
                    icon: Icon(CupertinoIcons.bookmark),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookmarkView()),
                      );
                    },
                    label: Text('All Bookmarks'),
                  ),
                ],
              ),

              // ! =========
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: buidNewsCard(r, textThem),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(),
              ),

              SizedBox(height: r.hLarge),
            ],
          ),
        ),
      ),
    );
  }

  // ! Custom News Card
  Widget buidNewsCard(Responsive r, TextTheme textThem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: r.w * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset('assets/news.jpg', fit: BoxFit.cover),
              ),
            ),

            SizedBox(height: r.hLarge),

            // ! Title
            Text(
              "പാക്കിസ്ഥാൻ അതീവ ജാഗ്രതയിൽ, റാവൽപിണ്ടിയിൽ ഇന്ന് ഇമ്രാൻ ഖാൻ അനുകൂലികളുടെ പ്രതിഷേധ റാലി; കനത്ത സുരക്ഷ...",
              style: textThem.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
            ),

            SizedBox(height: r.hMedium),
            Text(
              "ഇന്ന് റാവൽപിണ്ടിയിൽ നടക്കാനിരിക്കെ കനത്ത ജാഗ്രതയോടെ പാക്കിസ്ഥാൻ. പാർട്ടി പ്രവർത്തകരുടെ നേതൃത്വത്തിൽ ...",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),

            SizedBox(height: r.hMedium),
            Text("Source : news today| Updated: 2 Hours Before "),
            SizedBox(height: r.hSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  label: Text(
                    'Share',
                    style: TextStyle(color: AppColors.error),
                  ),
                  icon: Transform.flip(
                    flipX: true,
                    child: Icon(CupertinoIcons.reply, color: AppColors.error),
                  ),
                ),

                TextButton.icon(
                  onPressed: () {},
                  label: Text(
                    'Bookmark',
                    style: TextStyle(color: AppColors.accentYellow),
                  ),

                  icon: Icon(
                    CupertinoIcons.bookmark_fill,
                    color: AppColors.accentYellow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
