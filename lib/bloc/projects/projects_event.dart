part of 'projects_bloc.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

class AddProject extends ProjectsEvent {
  final Project project;
  const AddProject({required this.project});

  @override
  List<Object?> get props => [project];
}

class UpdateProject extends ProjectsEvent {
  final Project project;
  const UpdateProject({required this.project});

  @override
  List<Object?> get props => [project];
}

class DeleteProject extends ProjectsEvent {
  final Project project;
  const DeleteProject({required this.project});

  @override
  List<Object?> get props => [project];
}

class RefreshProjects extends ProjectsEvent {
  const RefreshProjects();
}
