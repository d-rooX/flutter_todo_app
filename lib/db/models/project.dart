import 'package:flutter_todo_app/db/models/task.dart';
import 'package:sqflite/sqflite.dart';

class Project {
  int? id;
  String title;
  String emoji;
  DateTime? deadline;

  Project({this.id, required this.title, required this.emoji, this.deadline});

  Project.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        emoji = map['emoji'],
        deadline = DateTime.fromMillisecondsSinceEpoch(map['deadline'] ?? 0);

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['emoji'] = emoji;
    map['deadline'] = deadline?.millisecondsSinceEpoch;
    return map;
  }

  // RELATION
  late List<Task> tasks;
  Future<List<Task>> _getTasks(Database db) async {
    final List<Map<String, dynamic>> tasksMaps =
        await db.query('tasks', where: 'project_id=?', whereArgs: [id]);
    tasks = tasksMaps.map(Task.fromMap).toList();
    return tasks;
  }

  // CREATE
  Future create(final Database db) async {
    id = await db.insert('projects', toMap());
  }

  // READ
  static Future<List<Project>> getAll(final Database db) async {
    final List<Map<String, dynamic>> projects = await db.query('projects');
    final List<Project> models = projects.map(Project.fromMap).toList(growable: false);
    for (Project proj in models) {
      await proj._getTasks(db);
    }
    return models;
  }

  static Future<Project> getSingle(final Database db, int project_id) async {
    final Project proj = Project.fromMap(
        (await db.query('projects', where: 'id=?', whereArgs: [project_id])).single);
    await proj._getTasks(db);
    return proj;
  }
}

extension TasksList on List<Task> {
  double get donePercent {
    return this.fold<double>(0.0, (previousValue, element) {
      return previousValue + (element.isChecked ? 100 / this.length : 0.0);
    });
  }

  int get doneCount {
    return this.fold(0, (previousValue, element) {
      return previousValue + (element.isChecked ? 1 : 0);
    });
  }
}
