import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_event.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_state.dart';

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  final PageController pageController;

  NavbarBloc({PageController? pageController})
    : pageController = pageController ?? PageController(),
      super(const NavbarState()) {
    on<NavigationTabChanged>(_onNavigationTabChanged);
  }

  void _onNavigationTabChanged(
    NavigationTabChanged event,
    Emitter<NavbarState> emit,
  ) {
    emit(state.copyWith(selectedIndex: event.tabIndex));
    pageController.jumpToPage(event.tabIndex);
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
