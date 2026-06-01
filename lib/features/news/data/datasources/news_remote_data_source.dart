import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_response_model.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> fetchNews(String category);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final String apiBaseUrl;
  final String newsApiKey;
  final http.Client client;

  NewsRemoteDataSourceImpl({
    required this.apiBaseUrl, 
    required this.newsApiKey,
    required this.client,
  });

  @override
  Future<List<ArticleModel>> fetchNews(String category) async {
    final url = Uri.parse(
       "$apiBaseUrl/v2/everything?q=$category&sortBy=publishedAt&apiKey=$newsApiKey",
    );
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final newsResponse = NewsResponseModel.fromJson(jsonDecode(response.body));
      return newsResponse.articles;
    } else {
      throw Exception("Failed to load news");
    }
  }
}
