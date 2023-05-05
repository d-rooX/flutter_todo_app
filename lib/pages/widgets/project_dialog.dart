import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/datetime_extension.dart';
import 'package:flutter_todo_app/pages/widgets/emoji_selector.dart';

import '../../db/models/project.dart';

class ProjectDialog extends StatefulWidget {
  const ProjectDialog({Key? key, this.project, this.isEdit = false}) : super(key: key);
  final Project? project;
  final bool isEdit;

  @override
  State<ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  final TextEditingController titleController = TextEditingController();
  DateTime? chosenDeadline;
  String? emoji;
  late ProjectsBloc projectsBloc;

  @override
  void initState() {
    super.initState();

    projectsBloc = context.read<ProjectsBloc>();
    emoji = widget.project?.emoji;
    titleController.text = widget.project?.title ?? '';
    chosenDeadline ??= widget.project?.deadline;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? "Edit project" : "Create project"),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(label: Text("Project name")),
              autofocus: true,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Text(
                  "Deadline: ",
                  style: TextStyle(fontSize: 15),
                ),
                const Spacer(),
                Text(
                  chosenDeadline?.formatted ?? '------',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const Spacer(flex: 3),
                GestureDetector(
                  onTap: () async {
                    const tenYears = Duration(days: 365 * 10);
                    final DateTime now = DateTime.now();
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: now.subtract(tenYears),
                      lastDate: now.add(tenYears),
                    );
                    setState(() => chosenDeadline = pickedDate);
                  },
                  child: const Icon(Icons.alarm),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => chosenDeadline = null),
                  child: const Icon(Icons.close),
                )
              ],
            ),
            const SizedBox(height: 25),
            EmojiSelector(
              initialEmoji: widget.project?.emoji,
              onChange: (newEmoji) => emoji = newEmoji,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                emoji ??= '📝';
                if (widget.isEdit) {
                  projectsBloc.add(UpdateProject(
                    project: Project(
                      title: titleController.text,
                      emoji: emoji!,
                      deadline: chosenDeadline,
                      id: widget.project!.id,
                    ),
                  ));
                } else {
                  projectsBloc.add(
                    AddProject(
                      project: Project(
                        title: titleController.text,
                        emoji: emoji!,
                        deadline: chosenDeadline,
                      ),
                    ),
                  );
                }

                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
