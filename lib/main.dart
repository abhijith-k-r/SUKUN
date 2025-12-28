import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/services/qibla_repository.dart';
import 'package:sukun/core/services/quran_rep_impl.dart';
import 'package:sukun/core/services/quran_repository.dart';
import 'package:sukun/core/services/quran_rop_impl.dart';
import 'package:sukun/core/theme/app_theme.dart';
import 'package:sukun/features/auth/views/screens/splash_screen.dart';
import 'package:sukun/features/bottom_navbar/view_model/bloc/navbar_bloc.dart';
import 'package:sukun/features/dikr_counter/view_model/bloc/dhikr_bloc.dart';
import 'package:sukun/features/qibla/view_model/bloc/qibla_bloc.dart';
import 'package:sukun/features/quran/view_models/cubit/quran_home_cubit.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final quranRepo = QuranRepositoryImplement();
    final userRepo = UserQuranRepositoryImpl();
    final qiblaRepo =  QiblaRepository(); 
    const String? userId = null;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<QuranRepository>(create: (_) => quranRepo),
        RepositoryProvider<UserQuranRepository>(create: (_) => userRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => QuranHomeCubit(
              quranRepo: context.read<QuranRepository>(),
              userRepo: context.read<UserQuranRepository>(),
              userId: userId,
            ),
          ),
          BlocProvider(create: (_) => NavbarBloc()),
          BlocProvider<DhikrBloc>(create: (context) => DhikrBloc()),
          BlocProvider<QiblaBloc>(create: (context) => QiblaBloc(repository:qiblaRepo ),)
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SUKUN',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
