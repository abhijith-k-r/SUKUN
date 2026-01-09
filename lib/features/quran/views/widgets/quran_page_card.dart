// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/core/widgets/custom_snackbar_widgets.dart';
import 'package:sukun/features/quran/models/page_model.dart';
import 'package:sukun/features/quran/view_models/cubit/reader_cubit.dart';

class QuranPageCard extends StatefulWidget {
  final QuranPage page;

  const QuranPageCard({super.key, required this.page});

  @override
  State<QuranPageCard> createState() => _QuranPageCardState();
}

class _QuranPageCardState extends State<QuranPageCard> {
  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final theme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(theme),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.page.shouldShowBismillah) ...[
                    _buildBismillah(),
                    const SizedBox(height: 24),
                  ],

                  // Book-style continuous text
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: _buildContinuousText(theme),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: r.w * 0.2),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0D5C7), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.page.surahRange,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            constraints: const BoxConstraints(maxWidth: 65),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "جُزْ ${_convertToArabicNumber(widget.page.juzNumber)}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
                fontSize: 12,
                fontFamily: 'UthmanTaha',
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinuousText(bool isDark) {
    return Text.rich(
      TextSpan(children: _buildTextSpans(isDark)),
      textAlign: TextAlign.justify,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: 24,
        fontFamily: 'UthmanTaha',
        fontWeight: FontWeight.w400,
        height: 2.0,
        color: isDark ? AppColors.white : AppColors.black,
      ),
    );
  }

  List<InlineSpan> _buildTextSpans(bool isDark) {
    List<InlineSpan> spans = [];

    for (int i = 0; i < widget.page.ayahs.length; i++) {
      final ayah = widget.page.ayahs[i];

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: () {
              _showAyahActions(context, ayah);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColors.accentYellow
                      : AppColors.primaryGreen,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  _convertToArabicNumber(ayah.ayahNumberInSurah),
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'UthmanTaha',
                    color: isDark ? AppColors.white : AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      spans.add(const TextSpan(text: ' '));

      spans.add(
        TextSpan(
          text: ayah.text,
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'UthmanTaha',
            fontWeight: FontWeight.w400,
            height: 2.0,
            color: isDark ? AppColors.white : AppColors.black,
          ),
          recognizer: LongPressGestureRecognizer()
            ..onLongPress = () {
              if (mounted) {
                _showAyahActions(context, ayah);
              }
            },
        ),
      );

      if (i < widget.page.ayahs.length - 1) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    return spans;
  }

  Widget _buildBismillah() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      child: const Text(
        'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 28,
          fontFamily: 'UthmanTaha',
          fontWeight: FontWeight.w500,
          height: 2.0,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE0D5C7), width: 1)),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              '${_convertToArabicNumber(widget.page.pageNumber)}  ',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text('${widget.page.pageNumber} /604'),
          ],
        ),
      ),
    );
  }

  void _showAyahActions(BuildContext context, AyahData ayah) {
    final cubit = context.read<PageReaderCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Surah ${ayah.surahName} - Ayah ${_convertToArabicNumber(ayah.ayahNumberInSurah)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        ayah.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'UthmanTaha',
                          height: 2.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.content_copy,
                            label: 'Copy',
                            onTap: () => _copyAyah(context, ayah),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.share,
                            label: 'Share',
                            onTap: () => _shareAyah(context, ayah),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.play_arrow,
                            label: 'Play',
                            onTap: () {
                              cubit.setPlayingAyah(
                                ayah.surahNumber,
                                ayah.ayahNumber,
                              );
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.bookmark,
                            label: 'Bookmark',
                            onTap: () {
                              cubit.toggleBookmark(
                                ayah.ayahNumber,
                                ayah.surahNumber,
                                ayah.ayahNumberInSurah,
                                ayah.surahName,
                                ayah.text,
                              );
                              Navigator.pop(context);
                              customSnackBar(
                                context,
                                'Ayah bookmarked successfully',
                                Icons.done,
                                AppColors.primaryGreen,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyAyah(BuildContext context, AyahData ayah) {
    final textToCopy =
        '${ayah.text}\n\n(Surah ${ayah.surahName} - Ayah ${_convertToArabicNumber(ayah.ayahNumberInSurah)})';
    Clipboard.setData(ClipboardData(text: textToCopy));
    Navigator.pop(context);
    customSnackBar(
      context,
      'Copied successfully',
      Icons.done,
      AppColors.primaryGreen,
    );
  }

  void _shareAyah(BuildContext context, AyahData ayah) {
    const String appLink = "https://sukunweb.com/";
    final textToShare =
        "${ayah.text}\n\n(Surah ${ayah.surahName} - Ayah ${_convertToArabicNumber(ayah.ayahNumberInSurah)})\n\nRead more on Sukun: $appLink";
    Share.share(textToShare);
    Navigator.pop(context);
  }

  String _convertToArabicNumber(int number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicNumbers[int.parse(digit)])
        .join();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Card(
        color: AppColors.primaryGreen,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: AppColors.white),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
