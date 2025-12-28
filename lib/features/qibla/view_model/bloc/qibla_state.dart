import 'package:equatable/equatable.dart';
import 'package:sukun/features/qibla/model/qibla_data.dart';

abstract class QiblaState extends Equatable {
  const QiblaState();

  @override
  List<Object?> get props => [];
}

class QiblaInitial extends QiblaState {}

class QiblaLoading extends QiblaState {}

class QiblaLoaded extends QiblaState {
  final QiblaData qiblaData;
  final TimingsData? timingsData;
  final double compassHeading;
  final DateTime currentTime;

  const QiblaLoaded({
    required this.qiblaData,
    this.timingsData,
    this.compassHeading = 0,
    required this.currentTime,
  });

  double get qiblaDirection => qiblaData.direction - compassHeading;

  QiblaLoaded copyWith({
    QiblaData? qiblaData,
    TimingsData? timingsData,
    double? compassHeading,
    DateTime? currentTime,
  }) {
    return QiblaLoaded(
      qiblaData: qiblaData ?? this.qiblaData,
      timingsData: timingsData ?? this.timingsData,
      compassHeading: compassHeading ?? this.compassHeading,
      currentTime: currentTime ?? this.currentTime,
    );
  }

  @override
  List<Object?> get props => [
    qiblaData,
    timingsData,
    compassHeading,
    currentTime,
  ];
}

class QiblaError extends QiblaState {
  final String message;

  const QiblaError(this.message);

  @override
  List<Object?> get props => [message];
}
