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
