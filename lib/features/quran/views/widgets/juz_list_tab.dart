import 'package:flutter/material.dart';
import 'package:sukun/features/quran/models/juz_model.dart';
import 'package:sukun/features/quran/views/screens/reader_screen.dart';

// ============================================================================
// JUZ LIST TAB
// Displays Juz items like selecting a book volume
// ============================================================================

class JuzListTab extends StatelessWidget {
  final List<JuzElement> juz;

  const JuzListTab({super.key, required this.juz});

  @override
  Widget build(BuildContext context) {
    if (juz.isEmpty) {
      return const Center(child: Text('No Juz available'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: juz.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final juzItem = juz[index];
        return _JuzListItem(juzItem: juzItem);
      },
    );
  }
}


class _JuzListItem extends StatelessWidget {
  final JuzElement juzItem;
  const _JuzListItem({required this.juzItem});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final firstEntry = juzItem.verseMapping.entries.first;
    final surahRange = firstEntry.key;

    return ListTile(
      leading: CircleAvatar(child: Text('${juzItem.juzNumber}')),
      title: Text('Juz ${juzItem.juzNumber}', style: textTheme.bodyLarge),
      subtitle: Text(
        'Page ${_getJuzStartPage(juzItem.juzNumber)} • Surah $surahRange',
        style: textTheme.bodySmall,
      ),
      trailing: Text(
        _getArabicNumber(juzItem.juzNumber),
        style: const TextStyle(fontFamily: 'UthmanTaha', fontSize: 20),
        textDirection: TextDirection.rtl,
      ),
      onTap: () {
        // ✅ PERFECT JUZ NAVIGATION
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PageReaderScreen(initialJuz: juzItem.juzNumber),
          ),
        );
      },
    );
  }

  int _getJuzStartPage(int juzNumber) {
    const juzPageStarts = [
      1,
      22,
      44,
      60,
      82,
      102,
      122,
      142,
      162,
      179,
      197,
      215,
      231,
      248,
      265,
      280,
      295,
      310,
      325,
      337,
      349,
      360,
      370,
      381,
      391,
      402,
      412,
      422,
      431,
      441,
    ];
    return juzPageStarts[juzNumber.clamp(1, 30) - 1];
  }

  String _getArabicNumber(int number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicNumbers[int.parse(digit)])
        .join();
  }
}
