class Article {
  int? id;
  String? title;
  final String? url;
  String? urlToImage;
  String? author;
  // String? description;
  // String? publishedAt;
  // String? content;

  Article({
    required this.id,
    required this.title,
    required this.url,
    required this.urlToImage,
    required this.author,
    // required this.description,
    // required this.publishedAt,
    // required this.content
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['id'],
        title: json['title'],
        url: json['url'] as String,
        urlToImage: json['urlToImage'],
        author: json['author'],
        // description: json['description'],
        // publishedAt: json['publishedAt'],
        // content: json['content'],
      );

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      title: map['title'],
      url: map['url'] as String,
      urlToImage: map['urlToImage'],
      author: map['author'],
      // description: map['description'],
      // publishedAt: map['publishedAt'],
      // content: map['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'urlToImage': urlToImage,
      'author': author,
      // 'description': description,
      // 'publishedAt': publishedAt,
      // 'content': content,
    };
  }
}
