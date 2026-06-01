import '../../domain/entities/article.dart';
import 'source_model.dart';

class ArticleModel extends Article {
  ArticleModel({
    required super.source,
    super.author,
    required super.title,
    super.description,
    required super.url,
    super.urlToImage,
    required super.publishedAt,
    super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      source: SourceModel.fromJson(json['source'] ?? {'name': 'Unknown'}),
      author: json['author'],
      title: json['title'] ?? 'No Title',
      description: json['description'],
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'],
    );
  }
}
