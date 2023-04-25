part of 'tasks_bloc.dart';

class TasksState extends Equatable {
  final Map<DateTime, List<Task>> tasksList;
  final DateTime selectedDay;

  const TasksState({required this.tasksList, required this.selectedDay});

  @override
  List<Object?> get props => [tasksList, selectedDay];
}
