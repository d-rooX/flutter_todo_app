part of 'tasks_bloc.dart';

class TasksState extends Equatable {
  final Map<int, List<Task>>? tasksList;
  final DateTime? selectedDay;

  const TasksState({this.tasksList, this.selectedDay});

  @override
  List<Object?> get props => [tasksList, selectedDay];
}
