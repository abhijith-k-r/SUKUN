import 'package:flutter/material.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_state.dart';
import 'package:sukun/features/quran/views/widgets/bookmark_list_widget.dart';
import 'package:sukun/features/quran/views/widgets/juz_list_widget.dart';
import 'package:sukun/features/quran/views/widgets/shurah_list._widget.dart';

//!  Tab Content
class TabContent extends StatelessWidget {
  final QuranHomeState state;
  const TabContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.currentTabIndex) {
      case 0:
        return SurahList(surahs: state.surahs);
      case 1:
        return JuzList(juz: state.juz);
      case 2:
        return BookmarkList(bookmarks: state.bookmarks);
      default:
        return const SizedBox.shrink();
    }
  }
}
