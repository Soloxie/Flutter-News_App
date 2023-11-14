import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/WebView.dart';
import 'newsArticle.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String selectedCategory = 'general';

  Future<List<Article>> fetchNewsData() async {
    final String apiKey = 'b938bc2a44874eaa82e3df95269fd19d';
    final String baseUrl = 'https://newsapi.org/v2/top-headlines';
    String Url =
        "$baseUrl?country=us&category=$selectedCategory&apiKey=$apiKey";
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final articles = jsonData['articles'] as List<dynamic>;
      return articles
          .map((articleJson) => Article.fromJson(articleJson))
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Best News',
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildCategoryButton('general', 'General'),
                    buildCategoryButton('sports', 'Sports'),
                    buildCategoryButton('technology', 'Technology'),
                    buildCategoryButton('health', 'Health'),
                    buildCategoryButton('science', 'Science'),
                    buildCategoryButton('entertainment', 'Entertainment'),
                    buildCategoryButton('business', 'Business')
                  ],
                ),
              ),
              FutureBuilder<List<Article>>(
                  future: fetchNewsData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Text(
                          'Cannot establish connection with the server');
                    } else if (snapshot.hasError) {
                      return Text('Error${snapshot.error}');
                    } else {
                      final news = snapshot.data ?? [];

                      return Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: news.length,
                          itemBuilder: (context, index) {
                            final article = news[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NewsWebView(
                                          blogUrl: article.url,
                                          title: article.title,
                                          author: article.author,
                                          image: article.urlToImage,
                                        )));
                              },
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    article.urlToImage ??
                                        "https://images.pexels.com/photos/2820884/pexels-photo-2820884.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                                title: Text(
                                  article.title ?? "News Unavailable",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  article.author ?? "No Author",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryButton(String category, String CategoryName) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
        fetchNewsData();
      },
      child: Container(
        width: 80,
        height: 30,
        decoration: BoxDecoration(
            color: Colors.red[100], borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            CategoryName,
            style: TextStyle(
                color: category == selectedCategory
                    ? Colors.black
                    : Colors.red[600]),
          ),
        ),
      ),
    );
  }
}
