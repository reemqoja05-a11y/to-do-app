enum TaskPriority {
  urgent,
  medium,
  low,
}

enum TaskCategory {
  work,
  personal,
  health,
  general,
}

enum TaskFilter {
  all,
  pending,
  completed,
}

class Task {
  final String id;
  final String title;
  final String description;
  final String dueDateTime;
  final DateTime? dueDate;
  final TaskCategory category;
  final TaskPriority priority;
  final bool isCompleted;
  final String? completedAtText;
  final int subtasksCompleted;
  final int subtasksTotal;
  final List<String> assignees;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDateTime,
    this.dueDate,
    this.category = TaskCategory.general,
    this.priority = TaskPriority.medium,
    this.isCompleted = false,
    this.completedAtText,
    this.subtasksCompleted = 0,
    this.subtasksTotal = 0,
    this.assignees = const [],
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? dueDateTime,
    DateTime? dueDate,
    TaskCategory? category,
    TaskPriority? priority,
    bool? isCompleted,
    String? completedAtText,
    int? subtasksCompleted,
    int? subtasksTotal,
    List<String>? assignees,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDateTime: dueDateTime ?? this.dueDateTime,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAtText: completedAtText ?? this.completedAtText,
      subtasksCompleted: subtasksCompleted ?? this.subtasksCompleted,
      subtasksTotal: subtasksTotal ?? this.subtasksTotal,
      assignees: assignees ?? this.assignees,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDateTime': dueDateTime,
      'dueDate': dueDate?.toIso8601String(),
      'category': category.name,
      'priority': priority.name,
      'isCompleted': isCompleted,
      'completedAtText': completedAtText,
      'subtasksCompleted': subtasksCompleted,
      'subtasksTotal': subtasksTotal,
      'assignees': assignees,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      dueDateTime: json['dueDateTime'] as String? ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'] as String)
          : null,
      category: TaskCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TaskCategory.general,
      ),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAtText: json['completedAtText'] as String?,
      subtasksCompleted: json['subtasksCompleted'] as int? ?? 0,
      subtasksTotal: json['subtasksTotal'] as int? ?? 0,
      assignees: (json['assignees'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
