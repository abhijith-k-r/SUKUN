import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/features/dikr_counter/model/dhikr_model.dart';
import 'dhikr_event.dart';
import 'dhikr_state.dart';

class DhikrBloc extends Bloc<DhikrEvent, DhikrState> {
  Timer? _stopwatchTimer;

  DhikrBloc()
    : super(
        DhikrState(
          suggestedDhikrs: _getInitialDhikrs(),
          savedSessions: _getInitialSessions(),
          selectedDhikr: const Dhikr(
            id: '1',
            nameArabic: 'سُبْحَانَ اللَّهِ',
            nameEnglish: 'SubhanAllah wa Bihamdihi',
            target: 33,
          ),
          counter: 33,
          isStopwatchActive: true,
          stopwatchSeconds: 45,
        ),
      ) {
    on<SelectDhikr>(_onSelectDhikr);
    on<IncrementCounter>(_onIncrementCounter);
    on<ResetCounter>(_onResetCounter);
    on<ClearSelection>(_onClearSelection);
    on<ToggleStopwatch>(_onToggleStopwatch);
    on<UpdateStopwatch>(_onUpdateStopwatch);
    on<SaveProgress>(_onSaveProgress);
    on<ToggleTarget>(_onToggleTarget);
    on<ToggleHaptic>(_onToggleHaptic);

    // Start the stopwatch timer
    _startStopwatchTimer();
  }

  static List<Dhikr> _getInitialDhikrs() {
    return const [
      Dhikr(
        id: '1',
        nameArabic: 'سُبْحَانَ اللَّهِ',
        nameEnglish: 'SubhanAllah',
        target: 33,
      ),
      Dhikr(
        id: '2',
        nameArabic: 'الْحَمْدُ لِلَّهِ',
        nameEnglish: 'Alhamdulillah',
        target: 33,
      ),
      Dhikr(
        id: '3',
        nameArabic: 'اللَّهُ أَكْبَرُ',
        nameEnglish: 'Allahu Akbar',
        target: 34,
      ),
      Dhikr(
        id: '4',
        nameArabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
        nameEnglish: 'La hawla wa la quwwata illa billah',
        target: 100,
      ),
      Dhikr(
        id: '5',
        nameArabic: 'أَسْتَغْفِرُ اللَّهَ',
        nameEnglish: 'Astaghfirullah',
        target: 70,
      ),
    ];
  }

  static List<DhikrSession> _getInitialSessions() {
    // final now = DateTime.now();
    return [
      // DhikrSession(
      //   id: '1',
      //   name: 'Morning Adhkar',
      //   count: 100,
      //   timestamp: DateTime(now.year, now.month, now.day, 8, 0),
      //   goalMet: true,
      // ),
      // DhikrSession(
      //   id: '2',
      //   name: 'Salawat',
      //   count: 500,
      //   timestamp: now.subtract(const Duration(days: 1, hours: 2, minutes: 30)),
      //   goalMet: false,
      // ),
    ];
  }

  void _startStopwatchTimer() {
    _stopwatchTimer?.cancel();
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isStopwatchActive) {
        add(UpdateStopwatch());
      }
    });
  }

  void _onSelectDhikr(SelectDhikr event, Emitter<DhikrState> emit) {
    emit(
      state.copyWith(
        selectedDhikr: event.dhikr,
        counter: 0,
        stopwatchSeconds: 0,
      ),
    );
  }

  void _onIncrementCounter(IncrementCounter event, Emitter<DhikrState> emit) {
    emit(state.copyWith(counter: state.counter + 1));
  }

  void _onResetCounter(ResetCounter event, Emitter<DhikrState> emit) {
    emit(state.copyWith(counter: 0, stopwatchSeconds: 0));
  }

  void _onClearSelection(ClearSelection event, Emitter<DhikrState> emit) {
    emit(state.copyWith(clearSelection: true, counter: 0, stopwatchSeconds: 0));
  }

  void _onToggleStopwatch(ToggleStopwatch event, Emitter<DhikrState> emit) {
    emit(state.copyWith(isStopwatchActive: !state.isStopwatchActive));
  }

  void _onUpdateStopwatch(UpdateStopwatch event, Emitter<DhikrState> emit) {
    if (state.isStopwatchActive) {
      emit(state.copyWith(stopwatchSeconds: state.stopwatchSeconds + 1));
    }
  }

  void _onSaveProgress(SaveProgress event, Emitter<DhikrState> emit) {
    if (state.selectedDhikr != null && state.counter > 0) {
      final newSession = DhikrSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nameArabic: state.selectedDhikr!.nameArabic,
        nameEnglish: state.selectedDhikr!.nameEnglish,
        count: state.counter,
        timestamp: DateTime.now(),
        goalMet: state.counter >= state.selectedDhikr!.target,
        duration: Duration(seconds: state.stopwatchSeconds),
      );

      final updatedSessions = [newSession, ...state.savedSessions];
      emit(
        state.copyWith(
          savedSessions: updatedSessions,
          counter: 0,
          stopwatchSeconds: 0,
        ),
      );
    }
  }

  void _onToggleTarget(ToggleTarget event, Emitter<DhikrState> emit) {
    emit(state.copyWith(targetEnabled: !state.targetEnabled));
  }

  void _onToggleHaptic(ToggleHaptic event, Emitter<DhikrState> emit) {
    emit(state.copyWith(hapticEnabled: !state.hapticEnabled));
  }

  @override
  Future<void> close() {
    _stopwatchTimer?.cancel();
    return super.close();
  }
}
