import 'package:flutter/material.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/quran/views/screens/reader_screen.dart';

// ! =======(AGAIN ANOTHER SOMETHING) =======
class QuickAccessChips extends StatelessWidget {
  const QuickAccessChips({super.key});

  String _mapSurahNumberToShortName(int number) {
    switch (number) {
      case 67:
        return 'Al-Mulk';
      case 32:
        return 'As-Sajdah';
      case 18:
        return 'Al-Kahf';
      case 36:
        return 'Yaseen';
      default:
        return 'Surah $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    final quickAccessSurahs = const [67, 32, 18, 36];

    return SizedBox(
      height: r.w * 0.15,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quickAccessSurahs.length,
        itemBuilder: (context, index) {
          final surahNumber = quickAccessSurahs[index];
          final name = _mapSurahNumberToShortName(surahNumber);
          return ActionChip(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            label: Text(name),
            backgroundColor: AppColors.accentYellow,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PageReaderScreen(initialSurahNumber: surahNumber),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: r.wMedium),
      ),
    );
  }
}
