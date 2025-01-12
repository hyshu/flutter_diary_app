import 'package:calendar_example/infrastructure/db/database.dart';
import 'package:calendar_example/domain/entity/diary.dart';

class DiaryUseCase {
  final DiaryDatabase _database;

  DiaryUseCase(this._database);

  Future<int> createDiary(Diary diary) async {
    final db = await _database.database;
    return await db.insert('diary', diary.toMap());
  }

  Future<int> updateDiary(Diary diary) async {
    final db = await _database.database;
    return await db.update(
      'diary',
      diary.toMap(),
      where: 'id = ?',
      whereArgs: [diary.id],
    );
  }

  Future<int> deleteDiary(int id) async {
    final db = await _database.database;
    return await db.delete(
      'diary',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Diary>> getDiariesByDate(String date) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'diary',
      where: 'date = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) {
      return Diary.fromMap(maps[i]);
    });
  }

  Future<List<Diary>> getAllDiaries() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> maps = await db.query('diary');
    return List.generate(maps.length, (i) {
      return Diary.fromMap(maps[i]);
    });
  }
}
