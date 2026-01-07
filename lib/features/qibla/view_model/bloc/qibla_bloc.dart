// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:sukun/core/services/qibla_repository.dart';
import 'qibla_event.dart';
import 'qibla_state.dart';

class QiblaBloc extends Bloc<QiblaEvent, QiblaState> {
  final QiblaRepository repository;
  StreamSubscription<CompassEvent>? _compassSubscription;
  Timer? _timeUpdateTimer;

  QiblaBloc({required this.repository}) : super(QiblaInitial()) {
    on<LoadQiblaData>(_onLoadQiblaData);
    on<UpdateLocation>(_onUpdateLocation);
    on<UpdateCompassHeading>(_onUpdateCompassHeading);

    // Auto-load data on initialization
    add(LoadQiblaData());
  }

  Future<void> _onLoadQiblaData(
    LoadQiblaData event,
    Emitter<QiblaState> emit,
  ) async {
    emit(QiblaLoading());
    try {
      // Get current location
      final position = await repository.getCurrentLocation();

      // Fetch Qibla direction
      final qiblaData = await repository.getQiblaDirection(
        position.latitude,
        position.longitude,
      );

      // Fetch prayer timings
      final timingsData = await repository.getPrayerTimings(
        position.latitude,
        position.longitude,
      );

      emit(
        QiblaLoaded(
          qiblaData: qiblaData,
          timingsData: timingsData,
          currentTime: DateTime.now(),
        ),
      );

      // Start compass listening
      _startCompassListener();

      // Start time update timer
      _startTimeUpdateTimer();
    } catch (e) {
      emit(QiblaError(e.toString()));
    }
  }

  Future<void> _onUpdateLocation(
    UpdateLocation event,
    Emitter<QiblaState> emit,
  ) async {
    if (state is QiblaLoaded) {
      emit(QiblaLoading());
      add(LoadQiblaData());
    }
  }

  void _onUpdateCompassHeading(
    UpdateCompassHeading event,
    Emitter<QiblaState> emit,
  ) {
    if (state is QiblaLoaded) {
      emit(
        (state as QiblaLoaded).copyWith(
          compassHeading: event.heading,
          currentTime: DateTime.now(),
        ),
      );
    }
  }

  void _startCompassListener() {
    _compassSubscription?.cancel();
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading != null) {
        add(UpdateCompassHeading(event.heading!));
      }
    });
  }

  void _startTimeUpdateTimer() {
    _timeUpdateTimer?.cancel();
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is QiblaLoaded) {
        final currentState = state as QiblaLoaded;
        emit(currentState.copyWith(currentTime: DateTime.now()));
      }

      // add(UpdateTime());
    });
  }

  @override
  Future<void> close() {
    _compassSubscription?.cancel();
    _timeUpdateTimer?.cancel();
    return super.close();
  }
}
