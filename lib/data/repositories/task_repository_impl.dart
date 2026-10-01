import 'package:flutter/material.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;

  TaskRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Task>> getTasks() => _remoteDataSource.getTasks();

  @override
  Future<Task> addTask(Task task) => _remoteDataSource.addTask(task);

  @override
  Future<Task> updateTask(Task task) => _remoteDataSource.updateTask(task);

  @override
  Future<void> deleteTask(String id) => _remoteDataSource.deleteTask(id);

  @override
  Future<Task> toggleTaskStatus(String id, bool isCompleted) =>
      _remoteDataSource.toggleTaskStatus(id, isCompleted);

  @override
  void setLocale(Locale locale) => _remoteDataSource.setLocale(locale);
}
