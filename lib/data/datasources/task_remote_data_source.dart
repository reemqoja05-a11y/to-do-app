import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  final SupabaseClient _client;
  Locale _locale = const Locale('ar');

  TaskRemoteDataSource(this._client);

  void setLocale(Locale locale) {
    _locale = locale;
  }

  Future<List<Task>> getTasks() async {
    try {
      final data = await _client.from(AppConstants.tasksTable).select();
      if (data.isEmpty) {
        return _getSampleTasks();
      }
      return data
          .map((json) => Task.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _getSampleTasks();
    }
  }

  Future<Task> addTask(Task task) async {
    try {
      await _client.from(AppConstants.tasksTable).insert(task.toJson());
    } catch (e) {
      // Fallback to local storage
    }
    return task;
  }

  Future<Task> updateTask(Task task) async {
    try {
      await _client
          .from(AppConstants.tasksTable)
          .update(task.toJson())
          .eq('id', task.id);
    } catch (e) {
      // Fallback to local storage
    }
    return task;
  }

  Future<void> deleteTask(String id) async {
    try {
      await _client.from(AppConstants.tasksTable).delete().eq('id', id);
    } catch (e) {
      // Fallback to local storage
    }
  }

  Future<Task> toggleTaskStatus(String id, bool isCompleted) async {
    try {
      final data = await _client
          .from(AppConstants.tasksTable)
          .update({'isCompleted': isCompleted})
          .eq('id', id)
          .select();
      if (data.isNotEmpty) {
        return Task.fromJson(data.first as Map<String, dynamic>);
      }
    } catch (e) {
      // Fallback to local storage
    }
    return Task(
      id: id,
      title: '',
      description: '',
      dueDateTime: '',
      isCompleted: isCompleted,
    );
  }

  List<Task> _getSampleTasks() {
    if (_locale.languageCode == 'ar') {
      return [
        const Task(
          id: '1',
          title: 'إعداد مراجعة المشروع الفصلية',
          description: 'جمع مقاييس الإنتاجية وتقارير مؤشرات الأداء لعرضها على الإدارة.',
          dueDateTime: 'اليوم، ٤:٠٠ م',
          category: TaskCategory.work,
          priority: TaskPriority.urgent,
          isCompleted: false,
          subtasksCompleted: 3,
          subtasksTotal: 4,
          assignees: ['أحمد', 'سارة', 'فهد', 'نورة'],
        ),
        const Task(
          id: '2',
          title: 'موعد الفحص الطبي',
          description: 'استلام نتائج التحاليل قبل مقابلة الطبيب.',
          dueDateTime: 'غداً، ١٠:٠٠ ص',
          category: TaskCategory.health,
          priority: TaskPriority.medium,
          isCompleted: false,
        ),
        const Task(
          id: '3',
          title: 'شراء مستلزمات المنزل',
          description: 'حليب، بيض، زيت زيتون، وخبز طازج.',
          dueDateTime: '٢٤ أكتوبر',
          category: TaskCategory.personal,
          priority: TaskPriority.low,
          isCompleted: false,
        ),
        const Task(
          id: '4',
          title: 'تسليم تقرير المصروفات',
          description: 'الفواتير الضريبية وإيصالات السفر الرسمية لشهر سبتمبر.',
          dueDateTime: 'أمس',
          category: TaskCategory.work,
          priority: TaskPriority.medium,
          isCompleted: true,
          completedAtText: 'تم الإنجاز أمس',
        ),
        const Task(
          id: '5',
          title: 'إرسال ملخص الفريق الأسبوعي',
          description: 'مشاركة الأهداف المنجزة والتحديات عبر البريد الإلكتروني.',
          dueDateTime: '٢٠ أكتوبر',
          category: TaskCategory.work,
          priority: TaskPriority.medium,
          isCompleted: true,
          completedAtText: 'تم الإنجاز',
        ),
      ];
    } else {
      return [
        const Task(
          id: '1',
          title: 'Prepare quarterly project review',
          description:
              'Gather sprint metrics, KPI reports, and roadmap deck for stakeholders.',
          dueDateTime: 'Today, 4:00 PM',
          category: TaskCategory.work,
          priority: TaskPriority.urgent,
          isCompleted: false,
          subtasksCompleted: 3,
          subtasksTotal: 4,
          assignees: ['Alex', 'Sarah', 'David', 'Nora'],
        ),
        const Task(
          id: '2',
          title: 'Doctor appointment check-up',
          description: 'Pick up medical reports before consultation.',
          dueDateTime: 'Tomorrow, 10:00 AM',
          category: TaskCategory.health,
          priority: TaskPriority.medium,
          isCompleted: false,
        ),
        const Task(
          id: '3',
          title: 'Buy groceries for dinner',
          description: 'Milk, eggs, olive oil, and fresh sourdough.',
          dueDateTime: 'Oct 24',
          category: TaskCategory.personal,
          priority: TaskPriority.low,
          isCompleted: false,
        ),
        const Task(
          id: '4',
          title: 'Submit expense reimbursement',
          description: 'Attached receipts in the corporate portal.',
          dueDateTime: 'Yesterday',
          category: TaskCategory.work,
          priority: TaskPriority.medium,
          isCompleted: true,
          completedAtText: 'Completed yesterday',
        ),
        const Task(
          id: '5',
          title: 'Send weekly team update email',
          description: 'Share accomplished milestones and blockers via email.',
          dueDateTime: 'Oct 20',
          category: TaskCategory.work,
          priority: TaskPriority.medium,
          isCompleted: true,
          completedAtText: 'Completed Oct 20',
        ),
      ];
    }
  }
}
