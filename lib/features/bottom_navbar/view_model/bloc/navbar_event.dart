import 'package:equatable/equatable.dart';

abstract class NavbarEvent extends Equatable {
  const NavbarEvent();

  @override
  List<Object> get props => [];
}

class NavigationTabChanged extends NavbarEvent {
  final int tabIndex;

  const NavigationTabChanged(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}
