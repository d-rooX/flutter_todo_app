import 'package:flutter/material.dart';
import 'package:flutter_todo_app/pages/home.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/bloc_exports.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TasksBloc>(
          create: (context) => TasksBloc()..add(const RefreshTasks()),
        ),
        BlocProvider<ProjectsBloc>(
          create: (context) => ProjectsBloc()..add(const RefreshProjects()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.orange,
        ),
        home: const HomePage(),
      ),
    );
  }
}
