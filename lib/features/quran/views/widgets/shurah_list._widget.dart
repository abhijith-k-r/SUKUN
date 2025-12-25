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

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: surahs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final s = surahs[index];
        return ListTile(
          leading: CircleAvatar(child: Text('${s.id}')),
          title: Text(s.nameSimple, style: textTheme.bodyLarge),
          subtitle: Text(
            'The ${s.translatedName.name}   ',
            style: textTheme.bodySmall,
          ),
          trailing: Column(
            children: [
              Text(s.nameArabic, style: textTheme.titleMedium),
              Text('${s.versesCount} Ayahs', style: textTheme.titleMedium),
            ],
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
      },
    );
  }
}
