part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class AddTask extends TasksEvent {
  final Task task;
  const AddTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TasksEvent {
  final Task task;
  const UpdateTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TasksEvent {
  final Task task;
  const DeleteTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class RefreshTasks extends TasksEvent {
  const RefreshTasks();

  @override
  List<Object?> get props => [];
}

class ChangeSelectedDay extends TasksEvent {
  final DateTime date;
  const ChangeSelectedDay({required this.date});

  @override
  List<Object?> get props => [date];
}
