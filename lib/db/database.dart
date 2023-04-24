import 'dart:io';

import 'package:flutter_todo_app/db/models/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _getDB();
    return _database!;
  }

  Future<Database> _getDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/tasks.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE tasks('
      'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      'title TEXT NOT NULL,'
      'emoji TEXT NOT NULL,'
      'date INTEGER,'
      'isChecked INTEGER NOT NULL'
      ')',
    );
  }

  DateTime toDate(DateTime dateTime) => DateTime(dateTime.year, dateTime.month, dateTime.day);

  // READ
  Future<List<Task>> getTasks(DateTime date) async {
    Database db = await getDatabase();
    final List<Map<String, dynamic>> tasksMaps = await db.query(
      'tasks',
      where: "date=?",
      whereArgs: [toDate(date).millisecondsSinceEpoch],
    );
    return tasksMaps.map((taskMap) => Task.fromMap(taskMap)).toList();
  }

  // CREATE
  Future<Task> createTask(Task task) async {
    Database db = await getDatabase();
    task.id = await db.insert('tasks', task.toMap());
    return task;
  }

  // UPDATE
  Future<int> updateTask(Task task) async {
    Database db = await getDatabase();
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id=?',
      whereArgs: [task.id],
    );
  }

  // DELETE
  Future<int> deleteTask(Task task) async {
    Database db = await getDatabase();
    return await db.delete(
      'tasks',
      where: 'id=?',
      whereArgs: [task.id],
    );
  }
}
