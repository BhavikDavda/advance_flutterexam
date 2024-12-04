import 'package:flutter/material.dart';
import '../../models/apimodels.dart';


class DetailPage extends StatelessWidget {
  final Article article;

  DetailPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              Image.network(article.imageUrl, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(article.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(article.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text(article.content, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
