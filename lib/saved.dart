import 'package:flutter/material.dart';
import 'package:news_app/bookmarkprovider.dart';
import 'package:news_app/model/databasehelper.dart';
import 'package:provider/provider.dart';

class BookmarkedNewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _dbHelper = DatabaseHelper();
    //final bookmarkProvider = Provider.of<BookmarkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked News'),
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbHelper.getBookmarkedArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Error message
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No saved articles'); // Message for no saved articles
          } else {
            final savedArticles = snapshot.data!;

            return ListView.builder(
              itemCount: savedArticles.length,
              itemBuilder: (context, index) {
                final savedArticle = savedArticles[index];
                return ListTile(
                  title: Text(savedArticle['title']),
                  // Add other fields like author and URL if needed
                );
              },
            );
          }
        },
      ),
      // body: ListView.builder(
      //   itemCount: bookmarkProvider.bookmarkedArticles.length,
      //   itemBuilder: (context, index) {
      //     final news = bookmarkProvider.bookmarkedArticles[index];
      //     return ListTile(
      //       title: Text(news.title ?? 'No title'),
      //       subtitle: Text(news.author ?? 'No author'),
      //       // Add an unbookmark button that removes the news from bookmarks.
      //       trailing: IconButton(
      //         icon: Icon(Icons.bookmark),
      //         onPressed: () {
      //           bookmarkProvider.removeBookmark(news);
      //         },
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
