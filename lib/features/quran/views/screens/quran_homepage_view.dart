import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/features/auth/view_models/cubit/auth_cubit.dart';
import 'package:sukun/features/quran/view_models/quran_home_cubit/quran_home_cubit.dart';
import 'package:sukun/features/quran/view_models/quran_home_cubit/quran_home_state.dart';
import 'package:sukun/features/quran/views/screens/quran_searchpge.dart';
import 'package:sukun/features/quran/views/widgets/bookmark_list_tab.dart';
import 'package:sukun/features/quran/views/widgets/juz_list_tab.dart';
import 'package:sukun/features/quran/views/widgets/quickaccess_chip_widget.dart';
import 'package:sukun/features/quran/views/widgets/surah_list_tab.dart';

class QuranHomeScreen extends StatelessWidget {
  const QuranHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuranHomeCubit(
        quranRepo: context.read<QuranRepository>(),
        userRepo: context.read<UserQuranRepository>(),
        userId: context.read<AuthCubit>().state.user?.id,
      )..loadData(),
      child: const _QuranHomeView(),
    );
  }
}

class _QuranHomeView extends StatelessWidget {
  const _QuranHomeView();

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/sukun_logo.png', width: r.fieldWidth * 0.4),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 🔥 NAVIGATE TO SEPARATE SEARCH PAGE
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuranSearchPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: BlocBuilder<QuranHomeCubit, QuranHomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 16),
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<QuranHomeCubit>().loadData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              QuickAccessChips(),
              _TabBar(
                currentTab: state.currentTab,
                onTabChanged: (index) {
                  context.read<QuranHomeCubit>().changeTab(index);
                },
              ),
              Expanded(
                child: IndexedStack(
                  index: state.currentTab,
                  children: [
                    SurahListTab(
                      surahs: state.surahs,
                      searchResults: state.searchResults,
                      isSearching: state.isSearchActive,
                    ),
                    JuzListTab(juz: state.juz),
                    BookmarkListTab(
                      bookmarks: state.bookmarks,
                      surahs: state.surahs,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final int currentTab;
  final Function(int) onTabChanged;

  const _TabBar({required this.currentTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _TabItem(
            label: 'Surah',
            isActive: currentTab == 0,
            onTap: () => onTabChanged(0),
          ),
          const SizedBox(width: 12),
          _TabItem(
            label: 'Juz',
            isActive: currentTab == 1,
            onTap: () => onTabChanged(1),
          ),
          const SizedBox(width: 12),
          _TabItem(
            label: 'Bookmarks',
            isActive: currentTab == 2,
            onTap: () => onTabChanged(2),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
