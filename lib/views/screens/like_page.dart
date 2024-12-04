import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/apimodels.dart';


class LikedNewsHeadlinesPage extends StatefulWidget {
  @override
  _LikedNewsHeadlinesPageState createState() => _LikedNewsHeadlinesPageState();
}

class _LikedNewsHeadlinesPageState extends State<LikedNewsHeadlinesPage> {
  List<Article> likedArticles = [];

  @override
  void initState() {
    super.initState();
    _loadLikedArticles();
  }

  void _loadLikedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticles = prefs.getStringList('likedArticles') ?? [];
    setState(() {
      likedArticles = savedArticles
          .map((article) => Article.fromJson(json.decode(article)))
          .toList();
    });
  }

  void _removeArticle(int index) async {
    final prefs = await SharedPreferences.getInstance();
    likedArticles.removeAt(index);
    final updatedArticles =
    likedArticles.map((article) => json.encode(article.toJson())).toList();
    await prefs.setStringList('likedArticles', updatedArticles);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Article removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Articles'),
      ),
      body: ListView.builder(
        itemCount: likedArticles.length,
        itemBuilder: (context, index) {
          final article = likedArticles[index];
          return ListTile(
            leading: article.imageUrl.isNotEmpty
                ? Image.network(article.imageUrl, width: 50, height: 50)
                : null,
            title: Text(article.title),
            subtitle: Text(article.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _removeArticle(index),
            ),
          );
        },
      ),
    );
  }
}
