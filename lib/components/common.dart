import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  const Section({Key? key, required this.title, required this.child, this.onSeeAll})
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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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

class TaskItem extends StatelessWidget {
  const TaskItem({Key? key, required this.title, required this.taskCount, required this.color})
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
            BackgroundIcon(
              color: color,
              child: const Icon(
                Icons.checklist_rounded,
                color: Colors.white,
                size: 18,
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

class RoundedTaskItem extends StatefulWidget {
  const RoundedTaskItem({Key? key, required this.emoji, required this.title}) : super(key: key);
  final String emoji;
  final String title;

  @override
  State<RoundedTaskItem> createState() => _RoundedTaskItemState();
}

class _RoundedTaskItemState extends State<RoundedTaskItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 80,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: isChecked ? Colors.grey.shade300 : Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          BackgroundIcon(
            color: Colors.grey.shade200,
            child: Text(
              widget.emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Text(
            widget.title,
            style: TextStyle(color: isChecked ? Colors.grey.shade500 : Colors.black),
          ),
          const Spacer(),
          Checkbox(
            activeColor: Colors.orange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            value: isChecked,
            onChanged: (oldValue) => setState(() => isChecked = !isChecked),
          ),
        ],
      ),
    );
  }
}

class BackgroundIcon extends StatelessWidget {
  const BackgroundIcon({Key? key, required this.color, required this.child}) : super(key: key);
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: child,
      ),
    );
  }
}
