import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

import './routines.dart';
import '../components/common.dart';
import '../components/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final List items = const [
    SizedBox(width: 25),
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
    SizedBox(width: 20),
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
              padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RandomAvatar('coolboy', height: 40, width: 40),
                      const SizedBox(width: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back,",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            "Nyava Hui",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: const [
                          Icon(CupertinoIcons.bell, size: 30),
                          SizedBox(width: 15),
                          Icon(Icons.menu, size: 30),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Icon(
                              CupertinoIcons.search,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintText: "Search",
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
