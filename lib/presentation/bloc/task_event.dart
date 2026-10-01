import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();
}

class AddTask extends TaskEvent {
  final Task task;
  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String id;
  const DeleteTask(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleTaskStatus extends TaskEvent {
  final String id;
  final bool isCompleted;
  const ToggleTaskStatus({required this.id, required this.isCompleted});

  @override
  List<Object?> get props => [id, isCompleted];
}

class ToggleFilter extends TaskEvent {
  final TaskFilter filter;
  const ToggleFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SwitchLanguage extends TaskEvent {
  final Locale locale;
  const SwitchLanguage(this.locale);

  @override
  List<Object?> get props => [locale];
}

class ToggleTheme extends TaskEvent {
  const ToggleTheme();
}
