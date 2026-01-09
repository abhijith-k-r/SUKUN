import 'package:flutter/material.dart';
import 'package:sukun/features/quran/models/bookmark_model.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';
import 'package:sukun/features/quran/views/screens/reader_screen.dart';


class BookmarkListTab extends StatelessWidget {
  final List<Bookmark> bookmarks;
  final List<Chapter> surahs;

  const BookmarkListTab({
    super.key,
    required this.bookmarks,
    required this.surahs,
  });

  @override
  Widget build(BuildContext context) {
    if (bookmarks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No bookmarks yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Long press on any Ayah to bookmark',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: bookmarks.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        final surah = _getSurahById(bookmark.surahNumber);
        return _BookmarkListItem(bookmark: bookmark, surah: surah);
      },
    );
  }

  Chapter? _getSurahById(int surahId) {
    try {
      return surahs.firstWhere((s) => s.id == surahId);
    } catch (e) {
      return null;
    }
  }
}



class _BookmarkListItem extends StatelessWidget {
  final Bookmark bookmark;
  final Chapter? surah;

  const _BookmarkListItem({required this.bookmark, required this.surah});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Open Page Reader and show the bookmarked Surah
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PageReaderScreen(
              initialSurahNumber: bookmark.surahNumber,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bookmark Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bookmark, color: Colors.amber),
            ),
            const SizedBox(width: 16),

            // Bookmark Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah?.nameSimple ?? 'Surah ${bookmark.surahNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ayah ${bookmark.ayahNumber}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(bookmark.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
