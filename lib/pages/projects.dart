import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/pages/widgets/appbar.dart' show BlurAppBar;
import 'package:flutter_todo_app/pages/widgets/project_dialog.dart';
import 'package:flutter_todo_app/pages/widgets/project_item.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  void showCreateProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ProjectDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade200,
      extendBodyBehindAppBar: true,
      appBar: BlurAppBar.blur(context, "Projects"),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateProjectDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) => ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: state.projectsList.length,
            itemBuilder: (context, index) => ProjectItem(project: state.projectsList[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 20),
          ),
        ),
      ),
    );
  }
}
