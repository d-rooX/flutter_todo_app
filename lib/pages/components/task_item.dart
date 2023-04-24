import 'package:flutter/material.dart';
import 'package:nyava_ui/db/database.dart';

import '../../db/models/task.dart';
import 'bg_icon.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({Key? key, required this.title, required this.taskCount, required this.color})
      : super(key: key);

  final Color color;
  final int taskCount;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            // strokeAlign: ,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          children: [
            BackgroundIcon(
              color: color,
              child: const Icon(
                Icons.checklist_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              "$taskCount tasks",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RoundedTaskItem extends StatefulWidget {
  const RoundedTaskItem(this.task, {Key? key}) : super(key: key);
  final Task task;

  @override
  State<RoundedTaskItem> createState() => _RoundedTaskItemState();
}

class _RoundedTaskItemState extends State<RoundedTaskItem> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 80,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: widget.task.isChecked ? Colors.grey.shade300 : Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          BackgroundIcon(
            color: Colors.grey.shade200,
            child: Text(
              widget.task.emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Text(
            widget.task.title,
            style: TextStyle(color: widget.task.isChecked ? Colors.grey.shade500 : Colors.black),
          ),
          const Spacer(),
          Checkbox(
            activeColor: Colors.orange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            value: widget.task.isChecked,
            onChanged: (oldValue) async {
              setState(() => widget.task.isChecked = !widget.task.isChecked);
              await DBProvider.db.updateTask(widget.task);
            },
          ),
        ],
      ),
    );
  }
}
