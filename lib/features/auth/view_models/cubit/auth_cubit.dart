import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/features/auth/view_models/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());
}
