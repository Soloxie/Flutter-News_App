import 'package:flutter/material.dart';
import 'package:news_app/newsArticle.dart';
import 'package:news_app/model/databasehelper.dart';

class BookmarkProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Article> _bookmarkedArticles = [];

  List<Article> get bookmarkedArticles => _bookmarkedArticles;

  Future<void> loadBookmarkedArticles() async {
    final rows = await _dbHelper.getBookmarkedArticles();
    _bookmarkedArticles = rows.map((row) => Article.fromMap(row)).toList();
    notifyListeners();
  }

  Future<void> toggleBookmark(Article article) async {
    if (_bookmarkedArticles.contains(article)) {
      _bookmarkedArticles.remove(article);
      await _dbHelper.deleteBookmark(article.id ?? 0);
    } else {
      _bookmarkedArticles.add(article);
      await _dbHelper.insertBookmark(article.toMap());
    }
    notifyListeners();
  }

  bool isBookmarked(String articleUrl) {
    return _bookmarkedArticles.any((article) => article.url == articleUrl);
  }
}
