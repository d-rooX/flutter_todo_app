import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/pages/widgets/section.dart';
import 'package:flutter_todo_app/pages/widgets/task_calendar.dart';
import 'package:flutter_todo_app/pages/widgets/task_dialog.dart';
import 'package:flutter_todo_app/pages/widgets/task_item.dart';

class RoutinesPage extends StatelessWidget {
  const RoutinesPage({Key? key}) : super(key: key);

  void createNewTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const TaskDialog(title: "Create task"),
    );
  }

  List<Widget> getTasksViews(TasksState state) {
    if (state.tasksList == null) {
      return [
        const Padding(
          padding: EdgeInsets.only(top: 25),
          child: CircularProgressIndicator(),
        )
      ];
    }
    return state.tasksList!
        .map<Widget>((task) => RoundedTaskItem(key: ValueKey("Task${task.id}}"), task))
        .toList()
      ..add(const SizedBox(height: 70));
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
        onPressed: () => createNewTask(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const TaskCalendar(),
          BlocBuilder<TasksBloc, TasksState>(
            builder: (context, state) {
              return Section(
                title: "Today Tasks",
                // onSeeAll: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(children: getTasksViews(state)),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
