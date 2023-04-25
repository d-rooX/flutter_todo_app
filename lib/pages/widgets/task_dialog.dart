import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/db/models/task.dart';

import 'bg_icon.dart';

final List<String> emojis =
    "😀 😃 😄 😁 😆 😅 😂 🤣 🥲 ☺️ 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐 🤓 😎 🥸 🤩 🥳 😏 😒 😞 😔 😟 😕 🙁 😣 😖 😫 😩 🥺 😢 😭 😤 😠 😡 🤬 🤯 😳 🥵 🥶 😱 😨 😰 😥 😓 🫣 🤗 🫡 🤔 🫢 🤭 🤫 🤥 😶 😶‍🌫️ 😐 😑 😬 🫨 🫠 🙄 😯 😦 😧 😮 😲 🥱 😴 🤤 😪 😵"
        .split(' ');

class TaskDialog extends StatelessWidget {
  const TaskDialog({Key? key, required this.title, this.isEdit = false, this.task})
      : super(key: key);
  final String title;
  final bool isEdit;
  final Task? task;

  @override
  Widget build(BuildContext context) {
    int selectedEmojiIndex = task != null ? emojis.indexOf(task!.emoji) : -1;
    DateTime date = context.read<TasksBloc>().state.selectedDay ?? DateTime.now();
    TextEditingController titleController = TextEditingController(text: task?.title);

    return AlertDialog(
      title: Text(title),
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 200,
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
                      color: index == selectedEmojiIndex ? Colors.orange : Colors.grey.shade200,
                      child: Text(emojis[index], style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                ),
              ),
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
                    String selectedEmoji =
                        selectedEmojiIndex == -1 ? '' : emojis[selectedEmojiIndex];
                    DateTime day = DateTime(date.year, date.month, date.day);
                    TasksBloc bloc = context.read<TasksBloc>();

                    if (isEdit) {
                      bloc.add(UpdateTask(
                        task: Task(titleController.text, selectedEmoji, day, id: task!.id),
                      ));
                    } else {
                      Task newTask = Task(titleController.text, selectedEmoji, day);
                      bloc.add(AddTask(task: newTask));
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
