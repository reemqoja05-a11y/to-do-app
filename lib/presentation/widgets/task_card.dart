import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';
import 'delete_task_dialog.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isArabic;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.isArabic,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  String _getCategoryName(TaskCategory category) {
    if (isArabic) {
      switch (category) {
        case TaskCategory.work:
          return 'عمل';
        case TaskCategory.personal:
          return 'شخصي';
        case TaskCategory.health:
          return 'صحة';
        case TaskCategory.general:
          return 'عام';
      }
    } else {
      switch (category) {
        case TaskCategory.work:
          return 'Work';
        case TaskCategory.personal:
          return 'Personal';
        case TaskCategory.health:
          return 'Health';
        case TaskCategory.general:
          return 'General';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = task.isCompleted;

    return Container(
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.surfaceContainerLight.withOpacity(0.85)
            : AppColors.surfaceContainerHighLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: isDone ? AppColors.secondaryLight : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDone
                      ? AppColors.secondaryLight
                      : AppColors.outlineLight.withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: isDone
                    ? [
                        BoxShadow(
                          color: AppColors.secondaryLight.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: isDone
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDone
                              ? AppColors.onSurfaceVariantLight
                              : AppColors.onSurfaceLight,
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!isDone && task.dueDateTime.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: task.priority == TaskPriority.urgent
                              ? AppColors.errorContainerLight.withOpacity(0.5)
                              : AppColors.surfaceContainerLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              task.priority == TaskPriority.urgent
                                  ? Icons.schedule
                                  : Icons.calendar_today,
                              size: 12,
                              color: task.priority == TaskPriority.urgent
                                  ? AppColors.tertiaryContainerLight
                                  : AppColors.onSurfaceVariantLight,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              task.dueDateTime,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: task.priority == TaskPriority.urgent
                                    ? AppColors.tertiaryContainerLight
                                    : AppColors.onSurfaceVariantLight,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (isDone && task.completedAtText != null)
                      Text(
                        task.completedAtText!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryLight,
                        ),
                      ),
                  ],
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: isDone
                          ? AppColors.outlineLight
                          : AppColors.onSurfaceVariantLight,
                      decoration: isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
                if (!isDone) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getCategoryName(task.category),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariantLight,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: onEdit,
                            borderRadius: BorderRadius.circular(16),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: AppColors.onSurfaceVariantLight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              DeleteTaskDialog.show(
                                context,
                                task: task,
                                isArabic: isArabic,
                                onConfirm: onDelete,
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: AppColors.errorLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
