import 'article_model.dart';

class NewsResponseModel {
  final String status;
  final int totalResults;
  final List<ArticleModel> articles;

  NewsResponseModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    return NewsResponseModel(
      status: json['status'] ?? 'error',
      totalResults: json['totalResults'] ?? 0,
      articles: json['articles'] != null 
          ? (json['articles'] as List).map((v) => ArticleModel.fromJson(v)).toList()
          : [],
    );
  }
}
