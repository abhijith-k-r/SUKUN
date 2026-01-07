// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/quran/view_models/surah_detail_cubit/surah_detail_cubit.dart';
import 'package:sukun/features/quran/view_models/surah_detail_cubit/surah_detail_state.dart';

// ============================================================================
// BOTTOM CONTROLS (Play, Display, Index)
// ============================================================================

class BottomControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayToggle;

  const BottomControls({
    super.key,
    required this.isPlaying,
    required this.onPlayToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating Play Button
            Transform.translate(
              offset: const Offset(0, -28),
              child: GestureDetector(
                onTap: onPlayToggle,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2DA463), Color(0xFF1E8B4D)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2DA463).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),

            // Bottom Toolbar
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BottomButton(
                    icon: Icons.text_fields,
                    label: 'Display',
                    onTap: () {
                      _showDisplayOptions(context);
                    },
                  ),
                  const SizedBox(width: 64),
                  BottomButton(
                    icon: Icons.format_list_bulleted,
                    label: 'Index',
                    onTap: () {
                      _showIndexSheet(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDisplayOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const DisplayOptionsSheet(),
    );
  }

  void _showIndexSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const IndexSheet(),
    );
  }
}

// ============================================================================
// BOTTOM BUTTON
// ============================================================================

class BottomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const BottomButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.grey500, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// DISPLAY OPTIONS SHEET
// ============================================================================

class DisplayOptionsSheet extends StatefulWidget {
  const DisplayOptionsSheet({super.key});

  @override
  State<DisplayOptionsSheet> createState() => _DisplayOptionsSheetState();
}

class _DisplayOptionsSheetState extends State<DisplayOptionsSheet> {
  double _arabicFontSize = 28;
  double _translationFontSize = 16;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey500,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Display Options',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          // Arabic Font Size
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Arabic Font Size',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${_arabicFontSize.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2DA463),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _arabicFontSize,
                  min: 20,
                  max: 40,
                  divisions: 20,
                  activeColor: const Color(0xFF2DA463),
                  onChanged: (value) {
                    setState(() {
                      _arabicFontSize = value;
                    });
                  },
                ),
              ],
            ),
          ),

          // Translation Font Size
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Translation Font Size',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${_translationFontSize.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2DA463),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _translationFontSize,
                  min: 12,
                  max: 24,
                  divisions: 12,
                  activeColor: const Color(0xFF2DA463),
                  onChanged: (value) {
                    setState(() {
                      _translationFontSize = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Apply Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Apply font settings
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2DA463),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ============================================================================
// INDEX SHEET (Verse List)
// ============================================================================

class IndexSheet extends StatelessWidget {
  const IndexSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey500,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Verse Index',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: BlocBuilder<SurahDetailCubit, SurahDetailState>(
                  builder: (context, state) {
                    if (state is SurahDetailLoaded) {
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: state.surah.verses.length,
                        itemBuilder: (context, index) {
                          final verse = state.surah.verses[index];
                          return ListTile(
                            leading: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2DA463).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${verse.verseNumber}',
                                  style: const TextStyle(
                                    color: Color(0xFF2DA463),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              verse.translation.length > 50
                                  ? '${verse.translation.substring(0, 50)}...'
                                  : verse.translation,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              // TODO: Scroll to verse
                            },
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
