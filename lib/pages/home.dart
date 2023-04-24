import 'package:flutter/material.dart';
import 'package:flutter_todo_app/pages/widgets/home.dart';
import 'package:flutter_todo_app/pages/widgets/routine_item.dart';
import 'package:flutter_todo_app/pages/widgets/section.dart';
import 'package:flutter_todo_app/pages/widgets/task_item.dart';

import 'routines.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final List items = const [
    SizedBox(width: 15),
    RoutineItem(
      emoji: "🌤",
      title: "Morning Routine",
      progress: 0.6,
    ),
    RoutineItem(
      emoji: "😠",
      title: "Depression",
      progress: 0.9,
    ),
    RoutineItem(
      emoji: "💩",
      title: "Shit pants",
      progress: 0.9,
    ),
    SizedBox(width: 15),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      bottomNavigationBar: SizedBox(
        height: 77,
        child: BottomNavigationBar(
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey.shade400,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: '',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, right: 25, left: 25),
              child: Column(
                children: const [
                  HomeHeader(),
                  SizedBox(height: 20),
                  HomeSearch(),
                ],
              ),
            ),
            Section(
              title: "Routines",
              onSeeAll: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) => const RoutinesPage(),
                );
                Navigator.of(context).push(route);
              },
              child: SizedBox(
                height: 160,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => items[index],
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 15),
                ),
              ),
            ),
            Section(
              title: "My Tasks",
              child: Column(
                children: const [
                  TaskItem(
                    color: Colors.teal,
                    title: "To Do",
                    taskCount: 5,
                  ),
                  TaskItem(
                    color: Colors.purple,
                    title: "In Progress",
                    taskCount: 9,
                  ),
                  TaskItem(
                    color: Colors.orange,
                    title: "Done",
                    taskCount: 21,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
