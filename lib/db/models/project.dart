import 'package:flutter_todo_app/db/models/task.dart';

class Project {
  int? id;
  String title;
  String emoji;
  DateTime? deadline;
  List<Task>? tasks; // resolves in DBProvider.getTask method

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
}
