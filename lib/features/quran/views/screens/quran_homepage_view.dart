// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/juz_model.dart';
import 'package:sukun/features/quran/models/reading_progress_model.dart';
import 'package:sukun/features/quran/models/surah_model.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_cubit.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_state.dart';

class QuranHomePage extends StatelessWidget {
  const QuranHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    // final textThem = Theme.of(context).textTheme;
    return BlocBuilder<QuranHomeCubit, QuranHomeState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: Image.asset(
              'assets/sukun_logo.png',
              width: r.fieldWidth * 0.4,
            ),
            actions: [
              Icon(Icons.language),
              SizedBox(width: r.wSmall),
              Icon(Icons.gps_fixed_rounded),
              SizedBox(width: r.wSmall),
              Icon(Icons.notifications_none),
              SizedBox(width: r.wSmall),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: r.w * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RecentlyReadCard(progress: state.lastReading),
                const SizedBox(height: 24),
                _QuickAccessChips(),
                const SizedBox(height: 16),
                _Tabs(state: state),
                const SizedBox(height: 8),
                _TabContent(state: state),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ! ========(SOMETHING ) ========

class _RecentlyReadCard extends StatelessWidget {
  final ReadingProgress? progress;

  const _RecentlyReadCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress == null) {
      // Guest user – just hide entire section
      return const SizedBox.shrink();
    }

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recently Read', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Al-Fatihah', // map from progress.surahNumber
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ayah ${progress!.ayahNumber}',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress!.percentage,
                        minHeight: 4,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Text('${(progress!.percentage * 100).round()}%'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to reading screen at saved surah/ayah
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2DA463),
                      minimumSize: const Size(90, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ! =========(ANOTHER SOMETHING) ========

class _Tabs extends StatelessWidget {
  final QuranHomeState state;
  const _Tabs({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuranHomeCubit>();

    Widget tab(String label, int index) {
      final selected = state.currentTabIndex == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => cubit.changeTab(index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryGreen
                  : AppColors.grey500.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab('Surahs', 0),
        const SizedBox(width: 8),
        tab('Juz', 1),
        const SizedBox(width: 8),
        tab('Bookmarks', 2),
      ],
    );
  }
}

// ! =======(AGAIN ANOTHER SOMETHING) ========

class _QuickAccessChips extends StatelessWidget {
  String _mapSurahNumberToShortName(int number) {
    switch (number) {
      case 67:
        return 'Al-Mulk';
      case 32:
        return 'As-Sajdah';
      case 18:
        return 'Al-Kahf';
      case 36:
        return 'Yaseen';
      default:
        return 'Surah $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    final quick = const [67, 32, 18, 36];

    return SizedBox(
      height: r.w * 0.15,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quick.length,

        itemBuilder: (context, index) {
          final name = _mapSurahNumberToShortName(quick[index]);
          return ActionChip(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            label: Text(name),
            backgroundColor: AppColors.accentYellow,
            onPressed: () {},
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: r.wMedium),
      ),
    );
  }
}

// ! =======(AGAIN ANOTHER SOMETHING) ========

class SurahList extends StatelessWidget {
  final List<Surah> surahs;
  const SurahList({super.key, required this.surahs});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: surahs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final s = surahs[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${s.number}')),
          title: Text(s.englishName, style: textTheme.bodyLarge),
          subtitle: Text('The ${s.meaning}   ', style: textTheme.bodySmall),
          trailing: Column(
            children: [
              Text(s.arabicName, style: textTheme.titleMedium),
              Text('${s.ayahCount} Ayahs', style: textTheme.titleMedium),
            ],
          ),
          onTap: () {
            // open surah screen
          },
        );
      },
    );
  }
}

// ! =======(AGAIN ANOTHER SOMETHING) ========

class JuzList extends StatelessWidget {
  final List<Juz> juz;
  const JuzList({super.key, required this.juz});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: juz.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final j = juz[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${j.number}')),
          title: Text(j.name),
          subtitle: Text('${j.start} → ${j.end}'), // map from data
          onTap: () {
            // open reader at first ayah of this juz
          },
        );
      },
    );
  }
}

// Tab Content
class _TabContent extends StatelessWidget {
  final QuranHomeState state;
  const _TabContent({required this.state});

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

// ! =======(AGAIN ANOTHER SOMETHING) ========

class BookmarkList extends StatelessWidget {
  final List<Bookmark> bookmarks;
  const BookmarkList({super.key, required this.bookmarks});

  @override
  Widget build(BuildContext context) {
    if (bookmarks.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.bookmark_border,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text('No bookmarks yet'),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final b = bookmarks[index];
        return ListTile(
          leading: const Icon(Icons.bookmark, color: Colors.amber),
          title: Text('Surah ${b.surahNumber}, Ayah ${b.ayahNumber}'),
          subtitle: Text(b.createdAt.toLocal().toString().split('.').first),
          onTap: () {
            // open reader at this ayah
          },
        );
      },
    );
  }
}
