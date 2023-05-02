import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Future<Database> get db async {
    return _database ?? await _getDB();
  }

  static Database? _database;

  static Future<Database> _getDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/tasks.db';
    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    return _database!;
  }

  static void _createDB(Database db, int version) async {
    await db.execute("PRAGMA foreign_keys = ON;");
    await db.execute(
      'CREATE TABLE projects('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'title TEXT NOT NULL,'
      'emoji TEXT NOT NULL,'
      'deadline INTEGER'
      ')',
    );
    await db.execute(
      'CREATE TABLE tasks('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'title TEXT NOT NULL,'
      'emoji TEXT NOT NULL,'
      'date INTEGER,'
      'isChecked INTEGER NOT NULL,'
      'project_id INTEGER,'
      'FOREIGN KEY(project_id) REFERENCES projects(id)'
      ')',
    );
  }
}
