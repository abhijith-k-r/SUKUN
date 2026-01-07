// ignore_for_file: deprecated_member_use
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/features/news/model/news_model.dart' hide Image;
import 'package:sukun/features/news/view_models/cubit/news_cubit.dart';
import 'package:sukun/features/news/views/screens/bookmark_view.dart';
import 'package:sukun/features/news/views/widgets/custom_news_card.dart';
import 'package:sukun/features/news/views/widgets/launc_url_helper.dart';

class PopularNews extends StatelessWidget {
  const PopularNews({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textThem = Theme.of(context).textTheme;
    final onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    return BlocBuilder<NewsCubit, SukunNewsState>(
      builder: (context, state) {
        List<Datum> allNews = state.news;

        if (state.isLoading) return Center(child: CircularProgressIndicator());
        if (state.errors.isNotEmpty) return Center(child: Text(state.errors));
        if (allNews.isEmpty) return Center(child: Text('No news available'));
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Image.asset(
              'assets/sukun_logo.png',
              width: r.fieldWidth * 0.4,
            ),

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
                            MaterialPageRoute(
                              builder: (context) => BookmarkView(),
                            ),
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
                    itemCount: allNews.length,
                    itemBuilder: (context, index) {
                      final newsItem = allNews[index];
                      return InkWell(
                        onTap: () =>
                            launchNewsUrl(context, newsItem.readMoreUrl),
                        child: buidNewsCard(r, textThem, newsItem),
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
      },
    );
  }

  
}
