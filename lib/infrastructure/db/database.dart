import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DiaryDatabase {
  static final DiaryDatabase _instance = DiaryDatabase._internal();
  static Database? _database;

  factory DiaryDatabase() {
    return _instance;
  }

  DiaryDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'diary.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE diary(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        content TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
