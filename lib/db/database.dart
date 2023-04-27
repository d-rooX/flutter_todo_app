import 'dart:io';

import 'package:flutter_todo_app/db/models/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/project.dart';

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

  // READ
  Future<Map<DateTime, List<Task>>> getTasks() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> tasks = await db.query('tasks');
    final List<Task> models = tasks.map(Task.fromMap).toList(growable: false);
    final Map<DateTime, List<Task>> dateSortedTasks = {};

    for (Task task in models) {
      dateSortedTasks.putIfAbsent(task.date, () => []).add(task);
    }
    return dateSortedTasks;
  }

  Future<List<Task>> getProjectTasks(int project_id) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> tasksMaps =
        await db.query('tasks', where: 'project_id=?', whereArgs: [project_id]);
    return tasksMaps.map(Task.fromMap).toList();
  }

  Future<List<Project>> getProjects() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> projects = await db.query('projects');
    final List<Project> models = projects.map(Project.fromMap).toList(growable: false);
    return models;
  }

  Future<Project> getProject(int project_id) async {
    final Database db = await getDatabase();
    final Project proj = Project.fromMap(
        (await db.query('projects', where: 'id=?', whereArgs: [project_id])).single);
    return proj;
  }

  // CREATE
  Future<Task> createTask(Task task) async {
    final Database db = await getDatabase();
    task.id = await db.insert('tasks', task.toMap());
    return task;
  }

  Future<Project> createProject(Project project) async {
    final Database db = await getDatabase();
    project.id = await db.insert('projects', project.toMap());
    return project;
  }

  // UPDATE
  Future<int> updateTask(Task task) async {
    final Database db = await getDatabase();
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id=?',
      whereArgs: [task.id],
    );
  }

  // DELETE
  Future<int> deleteTask(Task task) async {
    final Database db = await getDatabase();
    return await db.delete(
      'tasks',
      where: 'id=?',
      whereArgs: [task.id],
    );
  }
}
