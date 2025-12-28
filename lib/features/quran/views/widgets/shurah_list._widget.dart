import 'package:flutter/material.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';
import 'package:sukun/features/quran/views/screens/surah_reader_screen.dart';

// ! =======(AGAIN ANOTHER SOMETHING) ========
class SurahList extends StatelessWidget {
  final List<Chapter> surahs;
  const SurahList({super.key, required this.surahs});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Handle empty list gracefully
    if (surahs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No Surahs available',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Loading...',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: surahs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        try {
          if (index >= surahs.length) {
            return const SizedBox.shrink();
          }
          final s = surahs[index];
          return ListTile(
            leading: CircleAvatar(child: Text('${s.id}')),
            title: Text(s.nameSimple, style: textTheme.bodyLarge),
            subtitle: Text(
              'The ${s.translatedName.name}   ',
              style: textTheme.bodySmall,
            ),
            trailing: SingleChildScrollView(
              child: Column(
                children: [
                  Text(s.nameArabic, style: textTheme.titleMedium),
                  Text('${s.versesCount} Ayahs', style: textTheme.bodySmall),
                ],
              ),
            ),
            onTap: () {
              // open surah screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahReaderScreen(surahNumber: s.id),
                ),
              );
            },
          );
        } catch (e) {
          debugPrint('Error building surah list item at index $index: $e');
          return const SizedBox.shrink();
        }
      },
    );
  }
}
