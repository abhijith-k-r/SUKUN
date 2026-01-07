// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/core/theme/app_colors.dart';
import 'package:sukun/features/qibla/view/widgets/compas_widget.dart';
import 'package:sukun/features/qibla/view_model/bloc/qibla_bloc.dart';
import 'package:sukun/features/qibla/view_model/bloc/qibla_event.dart';
import 'package:sukun/features/qibla/view_model/bloc/qibla_state.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  String _getTimeUntil(DateTime target) {
    final now = DateTime.now();
    final difference = target.difference(now);

    if (difference.isNegative) return 'Passed';

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (hours > 0) {
      return 'In ${hours}h ${minutes}m';
    } else {
      return 'In ${minutes}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    final textThem = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/sukun_logo.png', width: r.fieldWidth * 0.4),
      ),
      body: SafeArea(
        child: BlocBuilder<QiblaBloc, QiblaState>(
          builder: (context, state) {
            if (state is QiblaLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF098958)),
              );
            }

            if (state is QiblaError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () =>
                            context.read<QiblaBloc>().add(LoadQiblaData()),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF098958),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is QiblaLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Compass
                    const SizedBox(height: 16),
                    CompassWidget(qiblaDirection: state.qiblaDirection),

                    // Current Date & Time
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 6),
                        Text(
                          'CURRENT DATE & TIME',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(state.currentTime),
                      style: textThem.headlineSmall,
                      //  const TextStyle(
                      //   fontSize: 20,
                      //   fontWeight: FontWeight.w600,
                      //   color: Color(0xFF334155),
                      // ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(state.currentTime),
                      style: textThem.headlineLarge,
                      // const TextStyle(
                      //   fontSize: 36,
                      //   fontWeight: FontWeight.bold,
                      //   color: Color(0xFF0F172A),
                      // ),
                    ),

                    // Next Prayer
                    if (state.timingsData?.nextPrayer != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F7F1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primaryGreen.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: AppColors.grey500,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'NEXT ADHAN',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey500,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'NEXT PRAYER',
                                style: textThem.bodySmall?.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              text: TextSpan(
                                style: textThem.headlineMedium,
                                children: [
                                  TextSpan(
                                    text:
                                        '${state.timingsData!.nextPrayer!.name} - ${state.timingsData!.nextPrayer!.time}',
                                    style: textThem.headlineMedium?.copyWith(
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _getTimeUntil(
                                      state.timingsData!.nextPrayer!.dateTime,
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.grey500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Location Info
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.grey500,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'YOUR LOCATION',
                              style: textThem.bodySmall?.copyWith(
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(state.qiblaData.locationName),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              margin: EdgeInsets.only(
                                right: 4,
                              ), // ← FIX spacing
                              decoration: BoxDecoration(
                                color: AppColors.lightBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Transform.rotate(
                                angle: -0.785398,
                                child: Icon(
                                  Icons.navigation,
                                  size: 12,
                                  color: AppColors.grey500,
                                ),
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                // ← Better text handling
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  style: textThem.bodyLarge,
                                  children: [
                                    TextSpan(text: 'Distance to Makkah: '),
                                    TextSpan(
                                      text:
                                          '${state.qiblaData.distanceToMakkah.toStringAsFixed(0)} km',
                                      style: textThem.bodyLarge?.copyWith(
                                        color: AppColors.primaryGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Location Status
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        Text(
                          'Current Location Status',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Location data is automatically detected.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF098958),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: BlocBuilder<QiblaBloc, QiblaState>(
        builder: (context, state) {
          if (state is QiblaLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: FloatingActionButton.extended(
                  onPressed: () =>
                      context.read<QiblaBloc>().add(UpdateLocation()),
                  backgroundColor: const Color(0xFF098958),
                  elevation: 8,
                  label: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.my_location, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Update Location',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
