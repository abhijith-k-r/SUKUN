import 'package:equatable/equatable.dart';

class Dhikr extends Equatable {
  final String id;
  final String nameArabic;
  final String nameEnglish;
  final int target;

  const Dhikr({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.target,
  });

  @override
  List<Object?> get props => [id, nameArabic, nameEnglish, target];
}

class DhikrSession extends Equatable {
  final String id;
  final String nameArabic;
  final String nameEnglish;
  final int count;
  final DateTime timestamp;
  final bool goalMet;
  final Duration? duration;

  const DhikrSession({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.count,
    required this.timestamp,
    required this.goalMet,
    this.duration,
  });

  @override
  List<Object?> get props => [
    id,
    nameArabic,
    nameEnglish,
    count,
    timestamp,
    goalMet,
    duration,
  ];
}
