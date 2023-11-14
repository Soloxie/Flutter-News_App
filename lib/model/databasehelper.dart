import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final pathToDb = path.join(dbPath, 'news.db');
    print('Database path: $pathToDb');

    return await openDatabase(
      pathToDb,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE bookmarks(id INTEGER PRIMARY KEY AUTO INCREMENT, title TEXT, author TEXT, url TEXT)');
      },
    );
  }

  //Insert to the table
  Future<void> insertBookmark(Map<String, dynamic> row) async {
    final db = await database;
    await db.insert('bookmarks', row);
  }

  //Delete from the table

  Future<void> deleteBookmark(int id) async {
    final db = await database;
    await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  //query the table
  Future<List<Map<String, dynamic>>> getBookmarkedArticles() async {
    final db = await database;
    return db.query('bookmarks');
  }
}
