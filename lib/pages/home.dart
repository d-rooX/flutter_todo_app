import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/bloc/projects/projects_bloc.dart';
import 'package:flutter_todo_app/db/database.dart';
import 'package:flutter_todo_app/pages/widgets/home.dart';
import 'package:flutter_todo_app/pages/widgets/project_item.dart';
import 'package:flutter_todo_app/pages/widgets/section.dart';
import 'package:flutter_todo_app/pages/widgets/task_item.dart';
import 'package:page_transition/page_transition.dart';

import '../db/models/project.dart';
import 'tasks.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget getProjectsViews(BuildContext context, ProjectsState state) {
    if (state.projectsList.isEmpty) {
      return Center(
        child: Text(
          "No projects yet...",
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => state.projectsList.isEmpty
          ? Text("No projects yet...")
          : ProjectItem(project: state.projectsList[index]),
      itemCount: state.projectsList.length,
      separatorBuilder: (context, index) => const SizedBox(width: 15),
    );
  }

  // void showCreateProjectDialog(BuildContext context) {
  //   showDialog(context: context, builder: (context) => const ProjectDialog());
  // }

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
              buttonName: "Create",
              // onButtonTap: () => showCreateProjectDialog(context),
              onButtonTap: () async {
                Project newProject = Project(emoji: '💩', title: 'New Project!');
                await DBProvider.db.createProject(newProject);
                context.read<ProjectsBloc>().add(RefreshProjects());
              },
              child: SizedBox(
                height: 160,
                child: BlocBuilder<ProjectsBloc, ProjectsState>(builder: getProjectsViews),
              ),
            ),
            Section(
              title: "My Tasks",
              onButtonTap: () {
                Navigator.of(context).push(PageTransition(
                  child: const RoutinesPage(),
                  type: PageTransitionType.fade,
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 500),
                  reverseDuration: Duration(milliseconds: 500),
                ));
              },
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
