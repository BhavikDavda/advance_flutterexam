class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String content;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['urlToImage'] ?? '',
      content: json['content'] ?? 'No Content Available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'content': content,
    };
  }
}
