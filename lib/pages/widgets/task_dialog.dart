import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/db/models/task.dart';

import 'bg_icon.dart';

final List<String> emojis =
    "😀 😃 😄 😁 😆 😅 😂 🤣 🥲 ☺️ 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐 🤓 😎 🥸 🤩 🥳 😏 😒 😞 😔 😟 😕 🙁 😣 😖 😫 😩 🥺 😢 😭 😤 😠 😡 🤬 🤯 😳 🥵 🥶 😱 😨 😰 😥 😓 🫣 🤗 🫡 🤔 🫢 🤭 🤫 🤥 😶 😶‍🌫️ 😐 😑 😬 🫨 🫠 🙄 😯 😦 😧 😮 😲 🥱 😴 🤤 😪 😵"
        .split(' ');

class TaskDialog extends StatelessWidget {
  const TaskDialog(
      {Key? key, required this.title, this.isEdit = false, this.task})
      : super(key: key);
  final String title;
  final bool isEdit;
  final Task? task;

  @override
  Widget build(BuildContext context) {
    TasksBloc bloc = context.read<TasksBloc>();
    int selectedEmojiIndex = task != null ? emojis.indexOf(task!.emoji) : -1;
    TextEditingController titleController =
        TextEditingController(text: task?.title);
    int? projectId;

    return AlertDialog(
      title: Text(title),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 280,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(label: Text("Name")),
              autofocus: true,
            ),
            SizedBox(
              height: 38,
              width: double
                  .maxFinite, // fixme: strange bug. it raises error unless specified on emulator 4a
              child: StatefulBuilder(
                builder: (context, setState) => ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: emojis.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => setState(() => selectedEmojiIndex = index),
                    child: BackgroundIcon(
                      color: index == selectedEmojiIndex
                          ? Colors.orange
                          : Colors.grey.shade200,
                      child: Text(emojis[index],
                          style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                ),
              ),
            ),
            DropdownMenu(
              onSelected: (value) => projectId = value,
              enableFilter: false,
              enableSearch: false,
              menuHeight: 200,
              dropdownMenuEntries: context
                  .read<ProjectsBloc>()
                  .state
                  .projectsList
                  .map(
                    (e) => DropdownMenuEntry(
                      value: e.id,
                      label: e.title,
                      leadingIcon: Text(e.emoji),
                    ),
                  )
                  .toList(growable: false),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isEdit)
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Choose date",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    String selectedEmoji = selectedEmojiIndex == -1
                        ? '📝'
                        : emojis[selectedEmojiIndex];

                    if (isEdit) {
                      bloc.add(UpdateTask(
                        task: Task(
                          titleController.text,
                          selectedEmoji,
                          bloc.state.selectedDay,
                          project_id: projectId,
                          id: task!.id,
                        ),
                      ));
                    } else {
                      bloc.add(
                        AddTask(
                          task: Task(
                            titleController.text,
                            selectedEmoji,
                            bloc.state.selectedDay,
                            project_id: projectId,
                          ),
                        ),
                      );
                    }

                    if (projectId != null) {
                      context.read<ProjectsBloc>().add(const RefreshProjects());
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
          ],
        ),
      ),
    );
  }
}
