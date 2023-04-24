import 'package:flutter/material.dart';

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
