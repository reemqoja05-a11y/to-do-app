import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> addTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String id);
  Future<Task> toggleTaskStatus(String id, bool isCompleted);
  void setLocale(Locale locale);
}
