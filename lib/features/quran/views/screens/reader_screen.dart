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

class _PageViewReader extends StatefulWidget {
  const _PageViewReader();

  @override
  State<_PageViewReader> createState() => _PageViewReaderState();
}

class _PageViewReaderState extends State<_PageViewReader> {
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness == Brightness.dark;
    return BlocConsumer<PageReaderCubit, PageReaderState>(
      listener: (context, state) {
        if (_pageController?.hasClients == true &&
            state.allPages.isNotEmpty &&
            state.currentPageIndex < state.allPages.length) {
          final targetPage = state.currentPageIndex;
          final currentPage = _pageController!.page?.round() ?? 0;
          if (targetPage != currentPage) {
            _pageController!.jumpToPage(targetPage);
          }
        }
      },
      builder: (context, state) {
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

        return Stack(
          children: [
            PageView.builder(
              controller: _pageController!,
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: state.allPages.length,
              onPageChanged: (index) {
                context.read<PageReaderCubit>().onPageChanged(index);
              },
              itemBuilder: (context, index) {
                if (index >= state.allPages.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final page = state.allPages[index];
                return QuranPageCard(page: page);
              },
            ),

            if (state.playingAyahNumber != null) ...[
              Positioned(
                bottom: 60,
                left: 24,
                right: 24,
                child: Card(
                  color: theme ? AppColors.lighblackBg : AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.music_note, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Ayah ${state.playingAyahNumber}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        // 🔥 FIXED: Correct Play/Pause Icon Logic
                        IconButton(
                          icon: Icon(
                            state.playingAyahNumber == null
                                ? Icons.play_arrow_rounded
                                : (state.isAudioPaused
                                      ? Icons.play_arrow_rounded
                                      : Icons.pause_rounded),
                          ),
                          onPressed: () {
                            if (state.playingAyahNumber == null) {
                              // No audio playing - show current page first ayah
                              final currentPage =
                                  state.allPages[state.currentPageIndex];
                              if (currentPage.ayahs.isNotEmpty) {
                                context.read<PageReaderCubit>().setPlayingAyah(
                                  currentPage.ayahs.first.surahNumber,
                                  currentPage.ayahs.first.ayahNumber,
                                );
                              }
                            } else if (state.isAudioPaused) {
                              context.read<PageReaderCubit>().resumeAudio();
                            } else {
                              context.read<PageReaderCubit>().pauseAudio();
                            }
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.skip_next_rounded),
                          onPressed: () =>
                              context.read<PageReaderCubit>().playNextAyah(),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.stop_rounded,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // 🔥 CRITICAL: Force stop and clear state
                            context.read<PageReaderCubit>().stopPlayback();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
