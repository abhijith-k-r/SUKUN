import 'package:flutter/material.dart';
import 'package:sukun/features/quran/models/bookmark_model.dart';

// ! =======(AGAIN ANOTHER SOMETHING) ========
class BookmarkList extends StatelessWidget {
  final List<Bookmark> bookmarks;
  const BookmarkList({super.key, required this.bookmarks});

  @override
  Widget build(BuildContext context) {
    // Always show the bookmark list UI, handle empty/null cases
    final safeBookmarks = bookmarks.isNotEmpty ? bookmarks : <Bookmark>[];

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (safeBookmarks.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No bookmarks yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bookmark verses to see them here',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          )
        else
          ...safeBookmarks.asMap().entries.map((entry) {
            try {
              final index = entry.key;
              final b = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.bookmark, color: Colors.amber),
                    title: Text('Surah ${b.surahNumber}, Ayah ${b.ayahNumber}'),
                    subtitle: Text(
                      b.createdAt.toLocal().toString().split('.').first,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        // TODO: Delete bookmark
                      },
                    ),
                    onTap: () {
                      // TODO: open reader at this ayah
                    },
                  ),
                  if (index < safeBookmarks.length - 1)
                    const Divider(height: 1),
                ],
              );
            } catch (e) {
              debugPrint(
                'Error building bookmark item at index ${entry.key}: $e',
              );
              return const SizedBox.shrink();
            }
          }),
      ],
    );
  }
}
