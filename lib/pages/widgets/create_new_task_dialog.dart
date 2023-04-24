import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/db/models/task.dart';

import 'bg_icon.dart';

class CreateNewTaskDialog extends StatelessWidget {
  const CreateNewTaskDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> emojis =
        "😀 😃 😄 😁 😆 😅 😂 🤣 🥲 ☺️ 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐 🤓 😎 🥸 🤩 🥳 😏 😒 😞 😔 😟 😕 🙁 😣 😖 😫 😩 🥺 😢 😭 😤 😠 😡 🤬 🤯 😳 🥵 🥶 😱 😨 😰 😥 😓 🫣 🤗 🫡 🤔 🫢 🤭 🤫 🤥 😶 😶‍🌫️ 😐 😑 😬 🫨 🫠 🙄 😯 😦 😧 😮 😲 🥱 😴 🤤 😪 😵"
            .split(' ');
    int selectedEmojiIndex = -1;
    DateTime date = context.read<TasksBloc>().state.selectedDay ?? DateTime.now();
    TextEditingController titleController = TextEditingController();

    return AlertDialog(
      title: const Text("Create new task"),
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
            ElevatedButton(
              onPressed: () {
                String selectedEmoji = selectedEmojiIndex == -1 ? '' : emojis[selectedEmojiIndex];
                DateTime day = DateTime(date.year, date.month, date.day);

                Task newTask = Task(titleController.text, selectedEmoji, day);
                context.read<TasksBloc>().add(AddTask(task: newTask));

                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
