import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/pages/widgets/appbar.dart' show BlurAppBar;
import 'package:flutter_todo_app/pages/widgets/section.dart';
import 'package:flutter_todo_app/pages/widgets/task_calendar.dart';
import 'package:flutter_todo_app/pages/widgets/task_dialog.dart';
import 'package:flutter_todo_app/pages/widgets/task_item.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  void showCreateTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const TaskDialog(title: "Create task"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      extendBodyBehindAppBar: true,
      appBar: BlurAppBar.blur(context, "Tasks"),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateTaskDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const TaskCalendar(),
          Section(
            title: "Today Tasks",
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: BlocBuilder<TasksBloc, TasksState>(
                builder: (context, state) => TasksList(
                  tasksList: state.tasksList[state.selectedDay] ?? [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
