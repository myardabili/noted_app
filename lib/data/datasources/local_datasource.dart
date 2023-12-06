import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class LocalDatasource {
  final String dbName = 'notes_local01.db';
  final String tableName = 'notes';

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            createdAt TEXT)''',
        );
      },
    );
  }

  Future<int> insetrtNote(Note note) async {
    final db = await _openDatabase();
    return await db.insert(tableName, note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await _openDatabase();
    final maps = await db.query(tableName, orderBy: 'createdAt DESC');
    return List.generate(maps.length, (index) => Note.fromMap(maps[index]));
  }

  Future<Note> getNoteById(int id) async {
    final db = await _openDatabase();
    final maps = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return Note.fromMap(maps.first);
  }

  Future<int> updateNoteById(Note note) async {
    final db = await _openDatabase();
    return await db.update(
      tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await _openDatabase();
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
