import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../app_config.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/get_news_usecase.dart';
import '../../data/datasources/news_remote_data_source.dart';
import '../../data/repositories/news_repository_impl.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final newsRemoteDataSourceProvider = Provider<NewsRemoteDataSource>((ref) {
  final config = ref.watch(appConfigProvider);
  final client = ref.watch(httpClientProvider);
  return NewsRemoteDataSourceImpl(
    apiBaseUrl: config.apiBaseUrl,
    newsApiKey: config.newsApiKey,
    client: client,
  );
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final remoteDataSource = ref.watch(newsRemoteDataSourceProvider);
  return NewsRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getNewsUseCaseProvider = Provider<GetNewsUseCase>((ref) {
  final repository = ref.watch(newsRepositoryProvider);
  return GetNewsUseCase(repository);
});

final newsProvider = FutureProvider.family<List<Article>, String>((ref, category) async {
  final getNewsUseCase = ref.watch(getNewsUseCaseProvider);
  return getNewsUseCase.execute(category);
});
