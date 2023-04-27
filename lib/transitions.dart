import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

PageTransition defaultTransition(Widget child) => PageTransition(
      child: child,
      type: PageTransitionType.fade,
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    );
