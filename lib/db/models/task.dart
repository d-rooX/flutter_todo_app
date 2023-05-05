import 'package:sqflite/sqflite.dart';

class Task {
  int? id;
  String title;
  String emoji;
  DateTime date;
  bool isChecked;
  int? projectID;

  // constructors
  Task(this.title, this.emoji, this.date, {this.id, this.projectID, this.isChecked = false});

  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        emoji = map['emoji'],
        date = DateTime.fromMillisecondsSinceEpoch(map['date']),
        projectID = map['project_id'],
        isChecked = map['isChecked'] == 1;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['emoji'] = emoji;
    map['date'] = date.millisecondsSinceEpoch;
    map['project_id'] = projectID;
    map['isChecked'] = isChecked ? 1 : 0;
    return map;
  }

  // CREATE
  Future create(final Database db) async {
    id = await db.insert('tasks', toMap());
  }

  // READ
  static Future<Map<DateTime, List<Task>>> getAll(final Database db) async {
    final List<Map<String, dynamic>> tasks = await db.query('tasks');
    final List<Task> models = tasks.map(Task.fromMap).toList(growable: false);
    final Map<DateTime, List<Task>> dateSortedTasks = {};

    for (Task task in models) {
      dateSortedTasks.putIfAbsent(task.date, () => []).add(task);
    }
    return dateSortedTasks;
  }

  // UPDATE
  Future<int> update(final Database db) async {
    return await db.update(
      'tasks',
      toMap(),
      where: 'id=?',
      whereArgs: [id],
    );
  }

  // DELETE
  Future<int> delete(final Database db) async {
    return await db.delete(
      'tasks',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
