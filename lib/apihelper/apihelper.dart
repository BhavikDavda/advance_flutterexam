import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apimodels.dart';

class ApiService {
  static const String _apiKey = '0624580a212346c0b1f408311eb1cdc1'; // Replace with your API key
  static const String _baseUrl = 'https://newsapi.org/v2'; // Use https for security

  // Fetch articles based on query parameters (e.g., search query, from date, sort)
  static Future<List<Article>> fetchArticles({
    String query = 'tesla', // Default query is 'tesla'
    String from = '2024-11-04', // Default from date
    String sortBy = 'publishedAt', // Default sortBy
  }) async {
    // Build the URL dynamically for the 'everything' endpoint
    final String url =
        '$_baseUrl/everything?q=$query&from=$from&sortBy=$sortBy&apiKey=$_apiKey';

    // Make the HTTP request
    final response = await http.get(Uri.parse(url));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse and return the articles
      final Map<String, dynamic> data = json.decode(response.body);
      final List articles = data['articles'];
      return articles.map((article) => Article.fromJson(article)).toList();
    } else {
      // Throw an error for any failure
      throw Exception('Failed to load articles: ${response.body}');
    }
  }
}
