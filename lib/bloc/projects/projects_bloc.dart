import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/db/database.dart';
import 'package:flutter_todo_app/db/models/project.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc() : super(ProjectsState(projectsList: [])) {
    on<RefreshProjects>(_onRefreshProjects);
  }

  void _onRefreshProjects(RefreshProjects event, Emitter<ProjectsState> emit) async {
    List<Project> projects = await DBProvider.db.getProjects();
    emit(ProjectsState(projectsList: projects));
  }
}
