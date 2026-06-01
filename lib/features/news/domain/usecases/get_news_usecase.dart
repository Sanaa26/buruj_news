import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetNewsUseCase {
  final NewsRepository repository;

  GetNewsUseCase(this.repository);

  Future<List<Article>> execute(String category) {
    return repository.getNews(category);
  }
}
