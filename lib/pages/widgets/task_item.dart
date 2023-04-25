import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/db/models/task.dart';
import 'package:flutter_todo_app/pages/widgets/task_dialog.dart';

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

class RoundedTaskItem extends StatelessWidget {
  const RoundedTaskItem(this.task, {Key? key}) : super(key: key);
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(15),
            onPressed: (context) => {
              showDialog(
                context: context,
                builder: (context) => TaskDialog(title: "Edit task", isEdit: true, task: task),
              )
            },
            backgroundColor: Colors.orangeAccent,
            icon: Icons.edit,
            foregroundColor: Colors.white,
          ),
          SlidableAction(
            borderRadius: BorderRadius.circular(15),
            onPressed: (context) => context.read<TasksBloc>().add(DeleteTask(task: task)),
            backgroundColor: Colors.red,
            icon: Icons.delete,
          ),
        ],
      ),
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: task.isChecked ? Colors.grey.shade300 : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            BackgroundIcon(
              color: Colors.grey.shade200,
              child: Text(
                task.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: Text(
                task.title,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(color: task.isChecked ? Colors.grey.shade500 : Colors.black),
              ),
            ),
            Checkbox(
              activeColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              value: task.isChecked,
              onChanged: (oldValue) {
                task.isChecked = !task.isChecked;
                context.read<TasksBloc>().add(UpdateTask(task: task));
              },
            ),
          ],
        ),
      ),
    );
  }
}
