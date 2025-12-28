import 'package:equatable/equatable.dart';

class QiblaData extends Equatable {
  final double latitude;
  final double longitude;
  final double direction;
  final String locationName;
  final double distanceToMakkah;

  const QiblaData({
    required this.latitude,
    required this.longitude,
    required this.direction,
    required this.locationName,
    required this.distanceToMakkah,
  });

  factory QiblaData.fromJson(Map<String, dynamic> json) {
    return QiblaData(
      latitude: json['data']['latitude'].toDouble(),
      longitude: json['data']['longitude'].toDouble(),
      direction: json['data']['direction'].toDouble(),
      locationName: '',
      distanceToMakkah: 0,
    );
  }

  QiblaData copyWith({
    double? latitude,
    double? longitude,
    double? direction,
    String? locationName,
    double? distanceToMakkah,
  }) {
    return QiblaData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      direction: direction ?? this.direction,
      locationName: locationName ?? this.locationName,
      distanceToMakkah: distanceToMakkah ?? this.distanceToMakkah,
    );
  }

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    direction,
    locationName,
    distanceToMakkah,
  ];
}

class PrayerTime extends Equatable {
  final String name;
  final String time;
  final DateTime dateTime;

  const PrayerTime({
    required this.name,
    required this.time,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [name, time, dateTime];
}

class TimingsData extends Equatable {
  final List<PrayerTime> prayers;
  final PrayerTime? nextPrayer;
  final String date;

  const TimingsData({
    required this.prayers,
    this.nextPrayer,
    required this.date,
  });

  factory TimingsData.fromJson(Map<String, dynamic> json) {
    final timings = json['data']['timings'] as Map<String, dynamic>;
    final date = json['data']['date']['readable'] as String;

    final now = DateTime.now();
    List<PrayerTime> prayersList = [];

    // Parse prayer times
    final prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    for (var name in prayerNames) {
      final timeStr = timings[name].toString().split(' ')[0]; // Remove timezone
      final timeParts = timeStr.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final prayerDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      prayersList.add(
        PrayerTime(name: name, time: timeStr, dateTime: prayerDateTime),
      );
    }

    // Find next prayer
    PrayerTime? nextPrayer;
    for (var prayer in prayersList) {
      if (prayer.dateTime.isAfter(now)) {
        nextPrayer = prayer;
        break;
      }
    }

    // If no prayer found today, next is Fajr tomorrow
    if (nextPrayer == null && prayersList.isNotEmpty) {
      final fajr = prayersList.first;
      final tomorrow = now.add(const Duration(days: 1));
      nextPrayer = PrayerTime(
        name: fajr.name,
        time: fajr.time,
        dateTime: DateTime(
          tomorrow.year,
          tomorrow.month,
          tomorrow.day,
          fajr.dateTime.hour,
          fajr.dateTime.minute,
        ),
      );
    }

    return TimingsData(
      prayers: prayersList,
      nextPrayer: nextPrayer,
      date: date,
    );
  }

  @override
  List<Object?> get props => [prayers, nextPrayer, date];
}
