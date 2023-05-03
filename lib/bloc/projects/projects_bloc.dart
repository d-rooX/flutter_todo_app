import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/db/database.dart';
import 'package:flutter_todo_app/db/models/project.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc() : super(const ProjectsState(projectsList: [])) {
    on<RefreshProjects>(_onRefreshProjects);
    on<AddProject>(_onAddProject);
  }

  void _onRefreshProjects(
      RefreshProjects event, Emitter<ProjectsState> emit) async {
    List<Project> projects = await Project.getAll(await DBProvider.db);
    emit(ProjectsState(projectsList: projects));
  }

  void _onAddProject(AddProject event, Emitter<ProjectsState> emit) async {
    await event.project.create(await DBProvider.db);
    add(const RefreshProjects());
  }
}
