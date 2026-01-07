import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sukun/core/services/news_repository.dart';
import 'package:sukun/features/news/model/news_model.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<SukunNewsState> {
  final NewsRepository newsRepo;
  NewsCubit({required this.newsRepo}) : super(NewsInitial()) {
    init();
  }

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));

    try {
      final newsData = await newsRepo.getNews();

      final loadedState = NewsLoaded(news: newsData);
      emit(loadedState);
    } catch (e) {
      debugPrint('QuranHomeCubit ERROR: $e');
      // On error, preserve existing data
      emit(state.copyWith(errors: e.toString(), isLoading: false));
    }
  }
}
