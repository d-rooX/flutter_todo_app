import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyava_ui/db/database.dart';
import 'package:nyava_ui/pages/components/bg_icon.dart';
import 'package:nyava_ui/pages/components/task_item.dart';

import '../db/models/task.dart';
import 'components/section.dart';
import 'components/task_calendar.dart';

class RoutinesPage extends StatefulWidget {
  const RoutinesPage({Key? key}) : super(key: key);

  @override
  State<RoutinesPage> createState() => _RoutinesPageState();
}

class _RoutinesPageState extends State<RoutinesPage> {
  List<Task>? taskList;
  List<String> emojis =
      "😀 😃 😄 😁 😆 😅 😂 🤣 🥲 ☺️ 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐 🤓 😎 🥸 🤩 🥳 😏 😒 😞 😔 😟 😕 🙁 😣 😖 😫 😩 🥺 😢 😭 😤 😠 😡 🤬 🤯 😳 🥵 🥶 😱 😨 😰 😥 😓 🫣 🤗 🫡 🤔 🫢 🤭 🤫 🤥 😶 😶‍🌫️ 😐 😑 😬 🫨 🫠 🙄 😯 😦 😧 😮 😲 🥱 😴 🤤 😪 😵"
          .split(' ');

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DBProvider.db.getTasks(DateTime(now.year, now.month, now.day)).then((value) {
      setState(() => taskList = value);
    });
  }

  void createNewTask() {
    int selectedEmojiIndex = -1;
    DateTime date = DateTime.now();
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create new task"),
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(label: Text("Name")),
                autofocus: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? chosenDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2999),
                      );
                      setState(() => date = chosenDate ?? date);
                    },
                    child: const Text(
                      "Choose date",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String selectedEmoji =
                          selectedEmojiIndex == -1 ? '' : emojis[selectedEmojiIndex];
                      DateTime day = DateTime(date.year, date.month, date.day);
                      Task newTask = Task(titleController.text, selectedEmoji, day);
                      newTask = await DBProvider.db.createTask(newTask);
                      setState(() => taskList?.add(newTask));
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.transparent),
          ),
        ),
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(CupertinoIcons.arrow_left),
        ),
        title: const Text('Routines'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 8,
        shadowColor: Colors.white.withAlpha(50),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const TaskCalendar(),
          Section(
            title: "Today Tasks",
            // onSeeAll: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: taskList?.map((task) => RoundedTaskItem(task)).toList() ??
                    [
                      const Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: CircularProgressIndicator(),
                      )
                    ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
