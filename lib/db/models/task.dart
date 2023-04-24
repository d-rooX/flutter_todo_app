class Task {
  int? id;
  String title;
  String emoji;
  DateTime date;
  bool isChecked;

  // constructors
  Task(this.title, this.emoji, this.date, {this.id, this.isChecked = false});
  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        emoji = map['emoji'],
        date = DateTime.fromMillisecondsSinceEpoch(map['date']),
        isChecked = map['isChecked'] == 1;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['emoji'] = emoji;
    map['date'] = date.millisecondsSinceEpoch;
    map['isChecked'] = isChecked ? 1 : 0;
    return map;
  }
}
