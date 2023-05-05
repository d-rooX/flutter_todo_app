import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:flutter_todo_app/datetime_extension.dart';
import 'package:flutter_todo_app/pages/widgets/project_dialog.dart';

import '../../db/models/project.dart';

class ProjectThumb extends StatelessWidget {
  const ProjectThumb({Key? key, required this.project}) : super(key: key);
  final Project project;

  @override
  Widget build(BuildContext context) {
    final double progress = project.tasks.donePercent / 100;

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
              project.emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Text(
            project.title,
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
  const ProjectItem({Key? key, required this.project}) : super(key: key);
  final Project project;

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
    final ProjectsBloc projectsBloc = context.read<ProjectsBloc>();
    bool isDone = (project.tasks.donePercent ~/ 100) == 1;

    Widget progressIndicator = Stack(
      alignment: Alignment.center,
      children: [
        if (isDone) ...[
          Container(
            constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
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
            onPressed: (context) => projectsBloc.add(DeleteProject(project: project)),
            backgroundColor: Colors.red,
            icon: Icons.delete,
          ),
        ],
      ),
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
                Text(
                  project.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  project.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
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
