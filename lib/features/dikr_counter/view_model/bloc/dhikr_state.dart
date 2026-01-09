import 'package:equatable/equatable.dart';
import 'package:sukun/features/dikr_counter/model/dhikr_model.dart';

class DhikrState extends Equatable {
  final Dhikr? selectedDhikr;
  final int counter;
   final bool showStopwatch; 
  final bool isTimerRunning;
  final int stopwatchSeconds;
  final bool targetEnabled;
  final bool hapticEnabled;
  final List<Dhikr> suggestedDhikrs;
  final List<DhikrSession> savedSessions;

  const DhikrState({
    this.selectedDhikr,
    this.counter = 0,
    this.showStopwatch = false, 
    this.isTimerRunning = false, 
    this.stopwatchSeconds = 0,
    this.targetEnabled = false,
    this.hapticEnabled = false,
    required this.suggestedDhikrs,
    required this.savedSessions,
  });

  DhikrState copyWith({
    Dhikr? selectedDhikr,
    bool clearSelection = false,
    int? counter,
    bool? showStopwatch,
    bool? isTimerRunning,
    int? stopwatchSeconds,
    bool? targetEnabled,
    bool? hapticEnabled,
    List<Dhikr>? suggestedDhikrs,
    List<DhikrSession>? savedSessions,
  }) {
    return DhikrState(
      selectedDhikr: clearSelection
          ? null
          : selectedDhikr ?? this.selectedDhikr,
      counter: counter ?? this.counter,
      showStopwatch: showStopwatch ?? this.showStopwatch,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      stopwatchSeconds: stopwatchSeconds ?? this.stopwatchSeconds,
      targetEnabled: targetEnabled ?? this.targetEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      suggestedDhikrs: suggestedDhikrs ?? this.suggestedDhikrs,
      savedSessions: savedSessions ?? this.savedSessions,
    );
  } 

  @override
  List<Object?> get props => [
    selectedDhikr,
    counter,
   showStopwatch,
    isTimerRunning, 
    stopwatchSeconds,
    targetEnabled,
    hapticEnabled,
    suggestedDhikrs,
    savedSessions,
  ];
}
