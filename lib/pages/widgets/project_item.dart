import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/datetime_extension.dart';
import 'package:flutter_todo_app/pages/widgets/appbar.dart';
import 'package:flutter_todo_app/pages/widgets/bg_icon.dart';
import 'package:flutter_todo_app/pages/widgets/project_dialog.dart';
import 'package:flutter_todo_app/pages/widgets/task_item.dart';

import '../../db/models/project.dart';

class ProjectThumb extends StatelessWidget {
  const ProjectThumb({Key? key, required this.project}) : super(key: key);
  final Project project;

  @override
  Widget build(BuildContext context) {
    final double progress = project.tasks.donePercent / 100;

    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackgroundIcon(
            color: Colors.grey.shade200,
            child: Text(
              project.emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 7),
          AutoSizeText(
            project.title,
            maxLines: 2,
            minFontSize: 10,
            overflow: TextOverflow.ellipsis,
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
                style: TextStyle(
                  color: progress.toInt() == 1 ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          LinearProgressIndicator(
            color: progress.toInt() == 1 ? Colors.green : Colors.orange,
            backgroundColor: Colors.grey.shade400,
            value: progress,
            minHeight: 5,
          ),
        ],
      ),
    );
  }
}

class ProjectItem extends StatelessWidget {
  const ProjectItem({Key? key, required this.project, this.isSlidable = true}) : super(key: key);
  final Project project;
  final bool isSlidable;

  Text getDaysToComplete() {
    int? daysLeft = project.deadline?.dayOnly.difference(DateTime.now().dayOnly).inDays;
    if (daysLeft == null) {
      return const Text('');
    } else if (daysLeft < 0) {
      return Text(
        "late for ${daysLeft * -1} days",
        style: const TextStyle(color: Colors.red),
      );
    } else {
      return Text(
        "$daysLeft days left",
        style: const TextStyle(color: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDone = (project.tasks.donePercent ~/ 100) == 1;

    Widget progressIndicator = Stack(
      alignment: Alignment.center,
      children: [
        if (isDone) ...[
          Container(
            height: 38,
            width: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          )
        ] else ...[
          CircularProgressIndicator(
            value: project.tasks.donePercent / 100,
            backgroundColor: Colors.grey,
          )
        ],
        if (isDone) ...[
          const Icon(Icons.done, color: Colors.white)
        ] else ...[
          Text(
            "${(project.tasks.donePercent).toStringAsFixed(0)}%",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ],
    );

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(15),
            onPressed: (context) => {
              showDialog(
                context: context,
                builder: (context) => ProjectDialog(
                  isEdit: true,
                  project: project,
                ),
              )
            },
            backgroundColor: Colors.orangeAccent,
            icon: Icons.edit,
            foregroundColor: Colors.white,
          ),
          SlidableAction(
            borderRadius: BorderRadius.circular(15),
            onPressed: (context) => context.read<ProjectsBloc>().add(
                  DeleteProject(
                    project: project,
                  ),
                ),
            backgroundColor: Colors.red,
            icon: Icons.delete,
          ),
        ],
      ),
      enabled: isSlidable,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                BackgroundIcon(
                  color: Colors.grey.shade200,
                  child: Text(
                    project.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AutoSizeText(
                    project.title,
                    maxLines: 2,
                    maxFontSize: 19,
                    minFontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                progressIndicator,
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  project.deadline?.dayOnly.formatted ?? '',
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                ),
                const Spacer(),
                getDaysToComplete(),
                const Spacer(flex: 2),
                Text(
                  project.tasks.doneCount.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "/",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  project.tasks.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key, required this.project}) : super(key: key);
  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlurAppBar.blur(context, project.title),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<ProjectsBloc, ProjectsState>(
          builder: (context, state) {
            Project _project =
                state.projectsList.where((element) => element.id == project.id).single;
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ProjectItem(project: _project, isSlidable: false),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: TasksList(tasksList: _project.tasks),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
