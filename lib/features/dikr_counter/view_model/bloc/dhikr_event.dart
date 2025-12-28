import 'package:equatable/equatable.dart';
import 'package:sukun/features/dikr_counter/model/dhikr_model.dart';

abstract class DhikrEvent extends Equatable {
  const DhikrEvent();

  @override
  List<Object?> get props => [];
}

class SelectDhikr extends DhikrEvent {
  final Dhikr dhikr;

  const SelectDhikr(this.dhikr);

  @override
  List<Object?> get props => [dhikr];
}

class IncrementCounter extends DhikrEvent {}

class ResetCounter extends DhikrEvent {}

class ClearSelection extends DhikrEvent {}

class ToggleStopwatch extends DhikrEvent {}

class UpdateStopwatch extends DhikrEvent {}

class SaveProgress extends DhikrEvent {}

class ToggleTarget extends DhikrEvent {}

class ToggleHaptic extends DhikrEvent {}
