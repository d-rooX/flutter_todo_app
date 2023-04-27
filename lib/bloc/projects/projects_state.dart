part of 'projects_bloc.dart';

class ProjectsState extends Equatable {
  final List<Project> projectsList;
  const ProjectsState({required this.projectsList});

  @override
  List<Object?> get props => [projectsList];
}
