part of 'news_cubit.dart';

class SukunNewsState {
  final List<Datum> news;
  // final List<Bookmark> bookmarks;
  final bool isLoading;
  final String errors;

  SukunNewsState({
    this.news = const [],
    this.isLoading = false,
    this.errors = '',
  });

  SukunNewsState copyWith({
    List<Datum>? news,
    bool? isLoading,
    String? errors,
  }) {
    return SukunNewsState(
      news: news ?? this.news,
      isLoading: isLoading ?? this.isLoading,
      errors: errors ?? this.errors,
    );
  }
}

class NewsInitial extends SukunNewsState {}

class NewsLoaded extends SukunNewsState {
  NewsLoaded({required super.news}) : super(isLoading: false);
}

class NewsError extends SukunNewsState {
  final String message;

  NewsError(this.message);
}
