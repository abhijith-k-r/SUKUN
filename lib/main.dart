import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/services/quran_rop_impl.dart';
import 'package:sukun/core/theme/app_theme.dart';
import 'package:sukun/features/auth/views/screens/splash_screen.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_bloc.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final quranRepo = QuranRepositoryImpl();
    final userRepo = UserQuranRepositoryImpl();
    const String? userId = null;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => QuranHomeCubit(
            quranRepo: quranRepo,
            userRepo: userRepo,
            userId: userId,
          ),
        ),
        BlocProvider(create: (_) => NavbarBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SUKUN',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}
