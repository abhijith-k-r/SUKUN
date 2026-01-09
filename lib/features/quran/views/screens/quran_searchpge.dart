// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/core/widgets/custom_snackbar_widgets.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';
import 'package:sukun/features/quran/views/screens/reader_screen.dart';
import 'package:sukun/features/quran/views/widgets/surah_list_tab.dart';

class QuranSearchPage extends StatefulWidget {
  const QuranSearchPage({super.key});

  @override
  State<QuranSearchPage> createState() => _QuranSearchPageState();
}

class _QuranSearchPageState extends State<QuranSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Chapter> _allSurahs = [];
  List<Chapter> _searchResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadSurahs() async {
    final quranRepo = context.read<QuranRepository>();
    try {
      final surahs = await quranRepo.getSurahs();
      setState(() {
        _allSurahs = surahs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      customSnackBar(
        context,
        'Failed to load Surahs: $e',
        Icons.error,
        AppColors.error,
      );
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    final results = _allSurahs.where((surah) {
      return surah.nameSimple.toLowerCase().contains(query) ||
          surah.nameArabic.contains(query) ||
          surah.id.toString().contains(query);
    }).toList();

    setState(() => _searchResults = results);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          textDirection: TextDirection.ltr, // 🔥 FIX: English typing
          decoration: InputDecoration(
            hintText: 'Search Surahs...',
            border: InputBorder.none,
            // hintStyle: TextStyle(color: Colors.white70),
          ),
          // style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty && _searchController.text.isEmpty
          ? _buildEmptyState()
          : _searchResults.isEmpty
          ? _buildNoResults()
          : _buildSearchResults(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: AppColors.grey500),
          const SizedBox(height: 16),
          Text(
            'Search Surahs',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Type to find Al-Fatiha, Yaseen, or any Surah number',
            style: TextStyle(color: AppColors.grey500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Surahs found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'Try "Fatiha", "Yaseen", or "18"',
            style: TextStyle(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final textThem = Theme.of(context).textTheme;
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final surah = _searchResults[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          leading: CircleAvatar(child: Text('${surah.id}')),
          title: Text(surah.nameSimple),
          subtitle: Text(getMalayalamMeaning(surah.id.toString())),
          trailing: SingleChildScrollView(
            child: Column(
              children: [
                Text(surah.nameArabic, style: textThem.titleSmall),
                Text('${surah.versesCount} Ayahs', style: textThem.titleSmall),
              ],
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PageReaderScreen(initialSurahNumber: surah.id),
              ),
            );
          },
        );
      },
    );
  }
}
