import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/db/database.dart';

import '../../db/models/task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTask>(_onUpdateTask);
    on<RefreshTasks>(_onRefreshTasks);
  }

  void _onRefreshTasks(RefreshTasks event, Emitter<TasksState> emit) async {
    List<Task> tasksList = await DBProvider.db.getTasks(event.date ?? DateTime.now());
    emit(TasksState(tasksList: tasksList, selectedDay: event.date));
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    await DBProvider.db.createTask(event.task);
    add(RefreshTasks(date: state.selectedDay));
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {}

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    await DBProvider.db.updateTask(event.task);
    add(RefreshTasks(date: state.selectedDay));
  }
}
