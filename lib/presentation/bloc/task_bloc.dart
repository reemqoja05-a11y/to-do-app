import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/load_tasks.dart';
import '../../domain/usecases/toggle_task_status.dart';
import '../../domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final LoadTasksUseCase loadTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final ToggleTaskStatusUseCase toggleTaskStatusUseCase;

  TaskBloc({
    required this.loadTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.toggleTaskStatusUseCase,
  }) : super(const TaskState()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskStatus>(_onToggleTaskStatus);
    on<ToggleFilter>(_onToggleFilter);
    on<SwitchLanguage>(_onSwitchLanguage);
    on<ToggleTheme>(_onToggleTheme);
  }

  Future<void> _onLoadTasks(
      LoadTasks event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final tasks = await loadTasksUseCase(const NoParams());
      emit(state.copyWith(
        status: TaskStatus.loaded,
        tasks: tasks,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.adding));
    try {
      final task = await addTaskUseCase(AddTaskParams(task: event.task));
      final updatedTasks = [task, ...state.tasks];
      emit(state.copyWith(
        status: TaskStatus.success,
        tasks: updatedTasks,
        successMessage: state.isArabic
            ? 'تم إضافة المهمة بنجاح'
            : 'Task added successfully',
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateTask(
      UpdateTask event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.updating));
    try {
      final task = await updateTaskUseCase(UpdateTaskParams(task: event.task));
      final updatedTasks = state.tasks
          .map((t) => t.id == task.id ? task : t)
          .toList();
      emit(state.copyWith(
        status: TaskStatus.success,
        tasks: updatedTasks,
        successMessage: state.isArabic
            ? 'تم تحديث المهمة بنجاح'
            : 'Task updated successfully',
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteTask(
      DeleteTask event, Emitter<TaskState> emit) async {
    emit(state.copyWith(status: TaskStatus.deleting));
    try {
      await deleteTaskUseCase(DeleteTaskParams(id: event.id));
      final updatedTasks = state.tasks.where((t) => t.id != event.id).toList();
      emit(state.copyWith(
        status: TaskStatus.success,
        tasks: updatedTasks,
        successMessage: state.isArabic
            ? 'تم حذف المهمة بنجاح'
            : 'Task deleted successfully',
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleTaskStatus(
      ToggleTaskStatus event, Emitter<TaskState> emit) async {
    try {
      final updatedTask = await toggleTaskStatusUseCase(
        ToggleTaskStatusParams(
            id: event.id, isCompleted: event.isCompleted),
      );
      final updatedTasks = state.tasks
          .map((t) => t.id == event.id ? updatedTask : t)
          .toList();
      emit(state.copyWith(
        status: TaskStatus.loaded,
        tasks: updatedTasks,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onToggleFilter(ToggleFilter event, Emitter<TaskState> emit) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onSwitchLanguage(SwitchLanguage event, Emitter<TaskState> emit) {
    emit(state.copyWith(locale: event.locale));
    add(const LoadTasks());
  }

  void _onToggleTheme(ToggleTheme event, Emitter<TaskState> emit) {
    final newMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(state.copyWith(themeMode: newMode));
  }
}
