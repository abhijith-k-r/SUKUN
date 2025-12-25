// ============================================================================
// UI - SURAH READER SCREEN (PageView with RTL)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';
import 'package:sukun/core/services/quran_repository.dart'; // Ensure this import exists
import 'package:sukun/features/quran/view_models/cubit/surah_detail_cubit.dart';
import 'package:sukun/features/quran/view_models/cubit/surah_detail_state.dart';

class SurahReaderScreen extends StatelessWidget {
  final int surahNumber;

  const SurahReaderScreen({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    // Inject the Cubit here so it's scoped to this screen
    return BlocProvider(
      create: (context) =>
          SurahDetailCubit(quranRepo: context.read<QuranRepository>())
            ..loadSurahDetail(surahNumber),
      child: const _SurahReaderView(),
    );
  }
}

class _SurahReaderView extends StatefulWidget {
  const _SurahReaderView();

  @override
  State<_SurahReaderView> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<_SurahReaderView> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SurahDetailCubit, SurahDetailState>(
        listener: (context, state) {
          if (state is SurahDetailLoading) {
            if (_pageController.hasClients) {
              _pageController.jumpToPage(0);
            }
          }
        },
        builder: (context, state) {
          if (state is SurahDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF17CF6A)),
            );
          }

          if (state is SurahDetailError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is SurahDetailLoaded) {
            // DEBUG: Check verses
            debugPrint(
              'Surah Loaded: ${state.surah.nameSimple}, Verses: ${state.surah.verses.length}',
            );

            // Just show the content page directly for now to avoid PageView issues
            return _SurahContentPage(surah: state.surah);
          }

          return const SizedBox();
        },
      ),
    );
  }
}

// ============================================================================
// UI - SURAH CONTENT PAGE
// ============================================================================

class _SurahContentPage extends StatelessWidget {
  final Chapter surah;

  const _SurahContentPage({required this.surah});

  String _getArabicNumber(int number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicNumbers[int.parse(digit)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    print("Building page with ${surah.verses.length} verses");
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              children: [
                Text(surah.nameSimple),
                Text(
                  '${surah.translatedName.name} • ${surah.id}',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryGreen,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),

          // Bismillah Header (skip for Surah 1 and 9)
          if (surah.id != 1 && surah.id != 9)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Divider(
                      color: AppColors.primaryGreen,
                      thickness: 1,
                      indent: 40,
                      endIndent: 40,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      color: theme ? AppColors.black : AppColors.white,
                      child: Text(
                        'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Verses
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final ayah = surah.verses[index];
              return _AyahCard(
                ayah: ayah,
                arabicNumber: _getArabicNumber(ayah.verseNumber),
              );
            }, childCount: surah.verses.length),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: _BottomControls(),
    );
  }
}

// ============================================================================
// UI - AYAH CARD
// ============================================================================

class _AyahCard extends StatelessWidget {
  final Ayah ayah;
  final String arabicNumber;

  const _AyahCard({required this.ayah, required this.arabicNumber});

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // padding: const EdgeInsets.all(20),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(12),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.03),
      //       blurRadius: 10,
      //       offset: const Offset(0, 2),
      //     ),
      //   ],
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Arabic Text Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Verse Number Badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.4),
                  ),
                ),
                child: Center(
                  child: Text(
                    arabicNumber,
                    style: GoogleFonts.amiri(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF17CF6A),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Arabic Text
              Expanded(
                child: Text(
                  ayah.translation,
                  // style: GoogleFonts.amiri(
                  //   fontSize: 26,
                  //   height: 2.0,
                  //   fontWeight: FontWeight.w500,
                  // ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Translation
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Text(
              ayah.translation,
              style: GoogleFonts.lexend(
                fontSize: 15,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// UI - BOTTOM CONTROLS
// ============================================================================

class _BottomControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.grey500, width: 1)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating Play Button
            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF17CF6A),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF17CF6A).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.play_arrow, size: 32),
              ),
            ),
            // Bottom Toolbar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BottomButton(
                    icon: Icons.text_fields,
                    label: 'Display',
                    onTap: () {},
                  ),
                  const SizedBox(width: 64), // Space for play button
                  _BottomButton(
                    icon: Icons.format_list_bulleted,
                    label: 'Index',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            // Progress Bar
            Container(
              height: 4,
              color: Colors.grey[200],
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.15,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF17CF6A),
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey[600], size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.lexend(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
