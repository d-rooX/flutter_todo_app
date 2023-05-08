import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/pages/projects.dart';
import 'package:flutter_todo_app/pages/widgets/home.dart';
import 'package:flutter_todo_app/pages/widgets/project_item.dart';
import 'package:flutter_todo_app/pages/widgets/section.dart';
import 'package:flutter_todo_app/pages/widgets/task_item.dart';

import '../transitions.dart';
import 'tasks.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget getProjectsView(BuildContext context, ProjectsState state) {
    if (state.projectsList.isEmpty) {
      return Center(
        child: Text(
          "No projects yet...",
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }
    const double padding = 20;
    List<Widget> projectsWithPadding = [
      const SizedBox(width: padding),
      ...state.projectsList.map(
        (project) => OpenContainer(
          closedColor: Colors.transparent,
          openColor: Colors.transparent,
          middleColor: Colors.transparent,
          transitionType: ContainerTransitionType.fade,
          closedElevation: 0,
          openElevation: 0,
          closedBuilder: (context, action) => ProjectThumb(project: project),
          openBuilder: (context, action) => ProjectPage(project: project),
        ),
      ),
      const SizedBox(width: padding),
    ];

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => projectsWithPadding[index],
      itemCount: projectsWithPadding.length,
      separatorBuilder: (context, index) => const SizedBox(width: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: ''),
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
              title: "Projects",
              onButtonTap: () =>
                  Navigator.of(context).push(defaultTransition(const ProjectsPage())),
              // context.read<ProjectsBloc>().add(
              //       AddProject(
              //         project: Project(
              //           title: "Shitty proj",
              //           emoji: "💩",
              //           deadline: DateTime.now().add(
              //             const Duration(days: 2),
              //           ),
              //         ),
              //       ),
              //     ),
              child: SizedBox(
                height: 160,
                child: BlocBuilder<ProjectsBloc, ProjectsState>(builder: getProjectsView),
              ),
            ),
            Section(
              title: "My Tasks",
              onButtonTap: () => Navigator.of(context).push(defaultTransition(const TasksPage())),
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
