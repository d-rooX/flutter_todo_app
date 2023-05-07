import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/db/models/task.dart';

import 'emoji_selector.dart';

class TaskDialog extends StatefulWidget {
  const TaskDialog({Key? key, required this.title, this.isEdit = false, this.task})
      : super(key: key);
  final String title;
  final bool isEdit;
  final Task? task;

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late final TasksBloc tasksBloc;
  late final ProjectsBloc projectsBloc;
  late final TextEditingController titleController;

  int? projectID;
  String? emoji;

  @override
  void initState() {
    super.initState();

    tasksBloc = context.read<TasksBloc>();
    projectsBloc = context.read<ProjectsBloc>();
    titleController = TextEditingController(text: widget.task?.title);

    emoji = widget.task?.emoji;
    projectID = widget.task?.projectID;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(label: Text("Name")),
              autofocus: true,
            ),
            const SizedBox(height: 25),
            EmojiSelector(
              initialEmoji: emoji,
              onChange: (newEmoji) => emoji = newEmoji,
            ),
            if (projectsBloc.state.projectsList.isNotEmpty)
              DropdownButton(
                value: projectID,
                onChanged: (value) => setState(() => projectID = value),
                items: projectsBloc.state.projectsList
                    .map((e) => DropdownMenuItem(value: e.id, child: Text(e.title)))
                    .toList(growable: false),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.isEdit)
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Choose date",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    emoji ??= '📝';
                    if (widget.isEdit) {
                      tasksBloc.add(
                        UpdateTask(
                          task: Task(
                            titleController.text,
                            emoji!,
                            tasksBloc.state.selectedDay,
                            projectID: projectID,
                            id: widget.task!.id,
                          ),
                        ),
                      );
                    } else {
                      tasksBloc.add(
                        AddTask(
                          task: Task(
                            titleController.text,
                            emoji!,
                            tasksBloc.state.selectedDay,
                            projectID: projectID,
                          ),
                        ),
                      );
                    }
                    context.read<ProjectsBloc>().add(const RefreshProjects());
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
