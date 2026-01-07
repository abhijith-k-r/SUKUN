// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/core/widgets/custom_snackbar_widgets.dart';
import 'package:sukun/features/quran/models/surahs_model.dart';
import 'package:sukun/features/quran/view_models/cubit/reader_cubit.dart';
import 'package:sukun/features/quran/view_models/cubit/reader_state.dart';

class PageAyahCard extends StatefulWidget {
  final Ayah ayah;
  final int surahNumber;

  const PageAyahCard({
    super.key,
    required this.ayah,
    required this.surahNumber,
  });

  @override
  State<PageAyahCard> createState() => _PageAyahCardState();
}

class _PageAyahCardState extends State<PageAyahCard> {
  bool showActions = false;

  String _getArabicNumber(int number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicNumbers[int.parse(digit)])
        .join();
  }

  // ============================================================================
  // QUICK ACTION BUTTON
  // ============================================================================

  void bottomController(BuildContext context, bool isBookmarked) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              Text(
                'Ayah Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 24),

              // Action Buttons Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _QuickAction(
                    icon: Icons.copy,
                    label: 'Copy',
                    onTap: () {
                      Navigator.pop(context);
                      _copyAyah(context);
                    },
                  ),
                  _QuickAction(
                    icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    label: isBookmarked ? 'Saved' : 'Bookmark',
                    color: isBookmarked ? Colors.amber : null,
                    onTap: () {
                      Navigator.pop(context);
                      _toggleBookmark(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _QuickAction(
                    icon: Icons.play_arrow,
                    label: 'Play',
                    onTap: () {
                      Navigator.pop(context);
                      _playAyah(context);
                    },
                  ),
                  _QuickAction(
                    icon: Icons.share,
                    label: 'Share',
                    onTap: () {
                      Navigator.pop(context);
                      _shareAyah();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<PageReaderCubit, PageReaderState>(
      builder: (context, state) {
        final cubit = context.read<PageReaderCubit>();
        final isBookmarked = cubit.isBookmarked(widget.ayah.id);
        final isPlaying = cubit.isPlaying(widget.ayah.id);

        return GestureDetector(
          onLongPress: () {
            // Show beautiful bottom sheet
            bottomController(context, isBookmarked);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPlaying
                  ? Colors.blue[50]
                  : (showActions
                        ? Colors.grey[50]
                        : (theme ? AppColors.black : AppColors.white)),
              border: Border.all(
                color: isPlaying
                    ? Colors.blue[200]!
                    : (showActions ? Colors.grey[300]! : Colors.grey[200]!),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Ayah Header Row
                Row(
                  children: [
                    // Ayah Number - Clearly shown
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getArabicNumber(widget.ayah.verseNumber),
                          style: const TextStyle(
                            fontFamily: 'UthmanTaha',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Bookmark Indicator
                    if (isBookmarked)
                      const Icon(Icons.bookmark, color: Colors.amber, size: 18),
                  ],
                ),

                const SizedBox(height: 16),

                // Arabic Text
                Text(
                  widget.ayah.text,
                  style: TextStyle(
                    fontFamily: 'UthmanTaha',
                    fontSize: 26,
                    height: 2,
                    fontWeight: FontWeight.w400,
                    fontFeatures: const [
                      FontFeature('liga', 1),
                      FontFeature('clig', 1),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),

                // Translation
                if (widget.ayah.translation.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.ayah.translation,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _copyAyah(BuildContext context) {
    final text =
        '''${widget.ayah.text}

${widget.ayah.translation}

[Surah ${widget.surahNumber}, Ayah ${widget.ayah.verseNumber}]''';

    Clipboard.setData(ClipboardData(text: text));
    customSnackBar(
      context,
      'Ayah copied to clipboard',
      Icons.copy_rounded,
      AppColors.primaryGreen,
    );
  }

  void _toggleBookmark(BuildContext context) {
    context.read<PageReaderCubit>().toggleBookmark(
      widget.ayah.id,
      widget.surahNumber,
      widget.ayah.verseNumber,
      '', // surahName not available
      widget.ayah.text,
    );

    final cubit = context.read<PageReaderCubit>();
    final isBookmarked = cubit.isBookmarked(widget.ayah.id);

    customSnackBar(
      context,
      isBookmarked ? 'Bookmark added' : 'Bookmark removed',
      isBookmarked ? Icons.bookmark : Icons.bookmark_remove,
      isBookmarked ? AppColors.primaryGreen : AppColors.error,
    );
  }

  void _playAyah(BuildContext context) {
    // Highlight currently playing Ayah
    context.read<PageReaderCubit>().setPlayingAyah(
      widget.surahNumber,
      widget.ayah.verseNumber,
    );

    // TODO: Implement actual audio playback

    customSnackBar(
      context,
      'Playing Ayah ${widget.ayah.verseNumber}',
      Icons.play_circle,
      AppColors.primaryGreen,
    );
  }

  void _shareAyah() {
    final text =
        '''${widget.ayah.text}

${widget.ayah.translation}

[Surah ${widget.surahNumber}, Ayah ${widget.ayah.verseNumber}]''';

    // ignore: deprecated_member_use
    Share.share(text);
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (color ?? Theme.of(context).primaryColor).withOpacity(
                  0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: color ?? Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
