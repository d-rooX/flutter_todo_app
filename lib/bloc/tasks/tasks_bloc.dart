import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo_app/datetime_extension.dart';
import 'package:flutter_todo_app/db/database.dart';

import '../../db/models/task.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(TasksState(selectedDay: DateTime.now().dayOnly, tasksList: const {})) {
    on<AddTask>(_onAddTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTask>(_onUpdateTask);
    on<RefreshTasks>(_onRefreshTasks);
    on<ChangeSelectedDay>(_onChangeSelectedDay);
  }

  void _onChangeSelectedDay(ChangeSelectedDay event, Emitter<TasksState> emit) {
    emit(TasksState(tasksList: state.tasksList, selectedDay: event.date));
  }

  void _onRefreshTasks(RefreshTasks event, Emitter<TasksState> emit) async {
    log("REFRESHED DB");
    Map<DateTime, List<Task>> tasksList = await DBProvider.db.getAllTasks();
    emit(TasksState(tasksList: tasksList, selectedDay: state.selectedDay));
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    await DBProvider.db.createTask(event.task);
    add(const RefreshTasks());
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    await DBProvider.db.deleteTask(event.task);
    add(const RefreshTasks());
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    await DBProvider.db.updateTask(event.task);
    add(const RefreshTasks());
  }
}
