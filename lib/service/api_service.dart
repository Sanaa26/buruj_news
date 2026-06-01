import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/new_sresponse.dart';

class ApiService {
  final String apiBaseUrl;
  final String newsApiKey;

  ApiService({required this.apiBaseUrl, required this.newsApiKey});

  Future<NewsResponse> fetchNews(String category) async {
    final url = Uri.parse(
       "$apiBaseUrl/v2/everything?q=$category&sortBy=publishedAt&apiKey=$newsApiKey",
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return NewsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load news");
    }
  }
}