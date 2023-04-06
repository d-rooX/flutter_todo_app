import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyava_ui/pages/routines.dart';
import 'package:random_avatar/random_avatar.dart';

void main() {
  runApp(const AppProxy());
}

class AppProxy extends StatelessWidget {
  const AppProxy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final List items = const [
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
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 15),
                ),
              ),
            ),
            Section(
              title: "My Tasks",
              child: Column(
                children: const [
                  TaskListItem(
                    color: Colors.teal,
                    title: "To Do",
                    taskCount: 5,
                  ),
                  TaskListItem(
                    color: Colors.purple,
                    title: "In Progress",
                    taskCount: 9,
                  ),
                  TaskListItem(
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

class TaskListItem extends StatelessWidget {
  const TaskListItem(
      {Key? key,
      required this.title,
      required this.taskCount,
      required this.color})
      : super(key: key);

  final Color color;
  final int taskCount;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            // strokeAlign: ,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.checklist_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              "$taskCount tasks",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RoutineItem extends StatelessWidget {
  const RoutineItem(
      {Key? key,
      required this.emoji,
      required this.title,
      required this.progress})
      : super(key: key);
  final String emoji;
  final String title;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 160,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Progress",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${(progress * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          LinearProgressIndicator(
            color: Colors.orange,
            backgroundColor: Colors.grey.shade400,
            value: progress,
            minHeight: 5,
          ),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  const Section(
      {Key? key, required this.title, required this.child, this.onSeeAll})
      : super(key: key);
  final String title;
  final Widget child;
  final GestureTapCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: const Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                )
            ],
          ),
        ),
        child
      ],
    );
  }
}
