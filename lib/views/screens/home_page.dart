import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../apihelper/apihelper.dart';
import '../../models/apimodels.dart';

import 'detailpage.dart';
import 'like_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;
  List<Article> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  void _fetchArticles() async {
    try {
      final fetchedArticles = await ApiService.fetchArticles(
        query: 'tesla',
        from: '2024-11-04',
        sortBy: 'publishedAt',
      );
      setState(() {
        articles = fetchedArticles;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching articles: $e')),
      );
    }
  }


  void _saveArticle(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticles = prefs.getStringList('likedArticles') ?? [];
    savedArticles.add(json.encode(article.toJson()));
    await prefs.setStringList('likedArticles', savedArticles);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Article saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Headlines'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LikedNewsHeadlinesPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal list of category buttons
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryButton('business'),
                _buildCategoryButton('entertainment'),
                _buildCategoryButton('health'),
                _buildCategoryButton('science'),
                _buildCategoryButton('sports'),
                _buildCategoryButton('technology'),
              ],
            ),
          ),
          // Display articles or loading indicator
          isLoading
              ? Expanded(
            child: Center(child: CircularProgressIndicator()),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  leading: article.imageUrl.isNotEmpty
                      ? Image.network(article.imageUrl, width: 50, height: 50)
                      : null,
                  title: Text(article.title),
                  subtitle: Text(article.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(article: article),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () => _saveArticle(article),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build category buttons
  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          selectedCategory == category ? Colors.blue : Colors.grey[300],
          foregroundColor:
          selectedCategory == category ? Colors.white : Colors.black,
        ),
        onPressed: () {
          // _fetchArticles(: category);
        },
        child: Text(category),
      ),
    );
  }
}
