import 'package:equatable/equatable.dart';

abstract class QiblaEvent extends Equatable {
  const QiblaEvent();

  @override
  List<Object?> get props => [];
}

class LoadQiblaData extends QiblaEvent {}

class UpdateLocation extends QiblaEvent {}

class UpdateCompassHeading extends QiblaEvent {
  final double heading;

  const UpdateCompassHeading(this.heading);

  @override
  List<Object?> get props => [heading];
}

class UpdateTime extends QiblaEvent {}
