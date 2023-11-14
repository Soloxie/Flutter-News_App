import 'package:flutter/material.dart';
import 'package:news_app/bookmarkprovider.dart';
import 'package:news_app/model/databasehelper.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatelessWidget {
  final blogUrl;
  final title;
  final author;
  final image;
  NewsWebView(
      {super.key,
      required this.blogUrl,
      required this.author,
      required this.title,
      required this.image});
  @override
  Widget build(BuildContext context) {
    final _dbHelper = DatabaseHelper();
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    bookmarkProvider
        .loadBookmarkedArticles(); // Load previously saved bookmarks

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            'Best News',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Consumer<BookmarkProvider>(
                builder: (context, bookmarkProvider, child) {
                  return Icon(
                    bookmarkProvider.isBookmarked(blogUrl)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                  );
                },
              ),
              onPressed: () async {
                bookmarkProvider.toggleBookmark(blogUrl);
                final articleMap = {
                  'title': title,
                  'author': author,
                  'url': blogUrl,
                };

                // Save the article to the database
                await _dbHelper.insertBookmark(articleMap);

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Article Saved'),
                      content: Text('This news article has been bookmarked.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: WebView(
              initialUrl: blogUrl,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ));
  }
}
