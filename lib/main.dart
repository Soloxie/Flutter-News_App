import 'package:news_app/bookmarkprovider.dart';
import 'package:news_app/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookmarkProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Best News',
        home: Homepage(),
      ),
    );
  }
}
