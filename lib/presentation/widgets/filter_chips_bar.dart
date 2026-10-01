import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';

class FilterChipsBar extends StatelessWidget {
  const FilterChipsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final isArabic = state.isArabic;
        final currentFilter = state.filter;

        final allCount = state.totalCount;
        final pendingCount = state.pendingCount;
        final completedCount = state.completedCount;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildChip(
                context,
                label: isArabic ? 'الكل ($allCount)' : 'All ($allCount)',
                isSelected: currentFilter == TaskFilter.all,
                onTap: () =>
                    context.read<TaskBloc>().add(const ToggleFilter(TaskFilter.all)),
              ),
              const SizedBox(width: 8),
              _buildChip(
                context,
                label: isArabic
                    ? 'قيد التنفيذ ($pendingCount)'
                    : 'Pending ($pendingCount)',
                isSelected: currentFilter == TaskFilter.pending,
                onTap: () => context
                    .read<TaskBloc>()
                    .add(const ToggleFilter(TaskFilter.pending)),
              ),
              const SizedBox(width: 8),
              _buildChip(
                context,
                label: isArabic
                    ? 'المكتملة ($completedCount)'
                    : 'Completed ($completedCount)',
                isSelected: currentFilter == TaskFilter.completed,
                onTap: () => context
                    .read<TaskBloc>()
                    .add(const ToggleFilter(TaskFilter.completed)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryContainerLight
              : AppColors.surfaceContainerHighLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.secondaryLight.withOpacity(0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(
                Icons.check,
                size: 16,
                color: AppColors.onSecondaryContainerLight,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.onSecondaryContainerLight
                    : AppColors.onSurfaceVariantLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
