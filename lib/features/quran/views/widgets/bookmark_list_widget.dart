import 'package:flutter/material.dart';
import 'package:sukun/features/quran/models/bookmark_model.dart';

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
