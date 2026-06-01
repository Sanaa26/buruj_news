import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_config.dart';
import '../model/new_sresponse.dart';
import '../service/api_service.dart';


final apiServiceProvider = Provider<ApiService>((ref) {
  final config = ref.watch(appConfigProvider);
  return ApiService(
    apiBaseUrl: config.apiBaseUrl,
    newsApiKey: config.newsApiKey,
  );
});

final newsProvider = FutureProvider.family<NewsResponse, String>((ref, category) async {
  final api = ref.read(apiServiceProvider);
  return api.fetchNews(category);
});