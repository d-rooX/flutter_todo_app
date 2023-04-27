import 'dart:ui';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension BlurAppBar on AppBar {
  static AppBar blur(BuildContext context, String name) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(color: Colors.transparent),
        ),
      ),
      toolbarHeight: 80,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(CupertinoIcons.arrow_left),
      ),
      title: Text(name),
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 8,
      shadowColor: Colors.white.withAlpha(50),
    );
  }
}
