import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';

enum TaskStatus {
  initial,
  loading,
  loaded,
  error,
  adding,
  updating,
  deleting,
  success,
}

class TaskState extends Equatable {
  final TaskStatus status;
  final List<Task> tasks;
  final TaskFilter filter;
  final Locale locale;
  final ThemeMode themeMode;
  final String? errorMessage;
  final String? successMessage;

  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.filter = TaskFilter.all,
    this.locale = const Locale('ar'),
    this.themeMode = ThemeMode.light,
    this.errorMessage,
    this.successMessage,
  });

  List<Task> get allTasks => List.unmodifiable(tasks);

  List<Task> get pendingTasks =>
      tasks.where((t) => !t.isCompleted).toList();

  List<Task> get completedTasks =>
      tasks.where((t) => t.isCompleted).toList();

  List<Task> get filteredTasks {
    switch (filter) {
      case TaskFilter.pending:
        return pendingTasks;
      case TaskFilter.completed:
        return completedTasks;
      case TaskFilter.all:
        return allTasks;
    }
  }

  int get totalCount => tasks.length;
  int get pendingCount => pendingTasks.length;
  int get completedCount => completedTasks.length;

  double get completionRatio =>
      totalCount == 0 ? 0.0 : (completedCount / totalCount);

  int get completionPercentage => (completionRatio * 100).round();

  bool get isArabic => locale.languageCode == 'ar';

  TaskState copyWith({
    TaskStatus? status,
    List<Task>? tasks,
    TaskFilter? filter,
    Locale? locale,
    ThemeMode? themeMode,
    String? errorMessage,
    String? successMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      filter: filter ?? this.filter,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tasks,
        filter,
        locale,
        themeMode,
        errorMessage,
        successMessage,
      ];
}
