import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/responsive/responsive.dart';
import 'package:sukun/features/dikr_counter/view/widgets/counter_section.dart';
import 'package:sukun/features/dikr_counter/view/widgets/saved_session_list.dart';
import 'package:sukun/features/dikr_counter/view/widgets/suggested_dhiker_list.dart';
import 'package:sukun/features/dikr_counter/view_model/bloc/dhikr_bloc.dart';
import 'package:sukun/features/dikr_counter/view_model/bloc/dhikr_event.dart';
import 'package:sukun/features/dikr_counter/view_model/bloc/dhikr_state.dart';

class DhikrCounterScreen extends StatelessWidget {
  const DhikrCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/sukun_logo.png', width: r.fieldWidth * 0.4),
      ),
      body: SafeArea(
        child: BlocBuilder<DhikrBloc, DhikrState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    CounterSection(
                      selectedDhikr: state.selectedDhikr,
                      counter: state.counter,
                      stopwatchSeconds: state.stopwatchSeconds,
                      isStopwatchActive: state.isStopwatchActive,
                      targetEnabled: state.targetEnabled,
                      hapticEnabled: state.hapticEnabled,
                      onTap: () =>
                          context.read<DhikrBloc>().add(IncrementCounter()),
                      onReset: () =>
                          context.read<DhikrBloc>().add(ResetCounter()),
                      onSave: () =>
                          context.read<DhikrBloc>().add(SaveProgress()),
                      onClearSelection: () =>
                          context.read<DhikrBloc>().add(ClearSelection()),
                      onToggleTarget: () =>
                          context.read<DhikrBloc>().add(ToggleTarget()),
                      onToggleHaptic: () =>
                          context.read<DhikrBloc>().add(ToggleHaptic()),
                      onToggleStopwatch: () =>
                          context.read<DhikrBloc>().add(ToggleStopwatch()),
                    ),
                    const SizedBox(height: 32),
                    SuggestedDhikrList(
                      dhikrs: state.suggestedDhikrs,
                      selectedDhikr: state.selectedDhikr,
                      onDhikrSelected: (dhikr) =>
                          context.read<DhikrBloc>().add(SelectDhikr(dhikr)),
                    ),
                    const SizedBox(height: 32),
                    SavedSessionsList(sessions: state.savedSessions),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
