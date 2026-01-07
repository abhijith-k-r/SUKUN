// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/auth/view_models/cubit/auth_cubit.dart';
import 'package:sukun/features/quran/view_models/cubit/reader_cubit.dart';
import 'package:sukun/features/quran/view_models/cubit/reader_state.dart';
import 'package:sukun/features/quran/views/widgets/quran_page_card.dart';

class PageReaderScreen extends StatelessWidget {
  final int? initialSurahNumber;
  final int? initialJuz;

  const PageReaderScreen({super.key, this.initialSurahNumber, this.initialJuz});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = PageReaderCubit(
          quranRepo: context.read<QuranRepository>(),
          userRepo: context.read<UserQuranRepository>(),
          userId: context.read<AuthCubit>().state.user?.id,
        );

        // ✅ IMMEDIATE LOAD - No postFrameCallback needed
        if (initialJuz != null) {
          cubit.loadQuranContent(initialJuz: initialJuz);
        } else {
          cubit.loadAllSurahs(initialSurahNumber: initialSurahNumber ?? 1);
        }

        return cubit;
      },
      child: const _PageReaderView(),
    );
  }
}

// ============================================================================
// PAGE READER VIEW
// ============================================================================

class _PageReaderView extends StatelessWidget {
  const _PageReaderView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: BlocBuilder<PageReaderCubit, PageReaderState>(
          builder: (context, state) {
            if (state.allPages.isNotEmpty) {
              final pageIndex = state.currentPageIndex.clamp(
                0,
                state.allPages.length - 1,
              );
              final page = state.allPages[pageIndex];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(page.surahRange, style: const TextStyle(fontSize: 18)),
                  Text(
                    'Page ${page.pageNumber} • Juz ${page.juzNumber}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              );
            }
            return const Text('Quran Reader');
          },
        ),
        centerTitle: true,
      ),
      body: const _PageViewReader(),
    );
  }
}

// ============================================================================
// PAGE VIEW READER - BULLETPROOF VERSION
// ============================================================================

class _PageViewReader extends StatefulWidget {
  const _PageViewReader();

  @override
  State<_PageViewReader> createState() => _PageViewReaderState();
}

class _PageViewReaderState extends State<_PageViewReader> {
  // ✅ SAFE: Always nullable, never 'late'
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    // ✅ IMMEDIATE SAFE INITIALIZATION
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // ✅ SAFE DISPOSE
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PageReaderCubit, PageReaderState>(
      listener: (context, state) {
        // ✅ 100% SAFE CONTROLLER CHECK
        if (_pageController?.hasClients == true &&
            state.allPages.isNotEmpty &&
            state.currentPageIndex < state.allPages.length) {
          final targetPage = state.currentPageIndex.clamp(
            0,
            state.allPages.length - 1,
          );
          if ((_pageController!.page?.round() ?? 0) != targetPage) {
            _pageController!.jumpToPage(targetPage);
          }
        }
      },
      builder: (context, state) {
        // ✅ LOADING SCREEN FIRST
        if (state.allPages.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading Quran pages...', style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        }

        // ✅ SAFE PAGEVIEW - Controller ALWAYS exists
        return PageView.builder(
          controller: _pageController!, // ✅ SAFE - Always initialized
          scrollDirection: Axis.horizontal,
          reverse: true, // RTL Quran reading
          itemCount: state.allPages.length + 1, // +1 for completion page
          onPageChanged: (index) {
            if (index >= state.allPages.length) {
              // Reached the end - show completion dialog
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showCompletionDialog(context);
              });
              return;
            }
            // ✅ SAFE INDEX
            context.read<PageReaderCubit>().onPageChanged(index);
          },
          itemBuilder: (context, index) {
            if (index >= state.allPages.length) {
              // Show completion page
              return _buildCompletionPage(context);
            }
            final page = state.allPages[index];
            return QuranPageCard(page: page);
          },
        );
      },
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Completion!'),
        content: const Text(
          'You have reached the end of this section. Great job!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue Reading'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to list
            },
            child: const Text('Back to List'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionPage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8F3),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.celebration, size: 64, color: Color(0xFF4A4A4A)),
            const SizedBox(height: 16),
            const Text(
              '🎉 You\'ve completed this section!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4A4A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Great job on your Quran reading journey!',
              style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A4A4A),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Back to List',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
