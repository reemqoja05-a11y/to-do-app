import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';
import '../../presentation/bloc/task_bloc.dart';
import '../../presentation/bloc/task_event.dart';
import '../../presentation/bloc/task_state.dart';
import '../../presentation/widgets/daily_momentum_banner.dart';
import '../../presentation/widgets/filter_chips_bar.dart';
import '../../presentation/widgets/task_bottom_nav_bar.dart';
import '../../presentation/widgets/task_card.dart';
import 'task_detail_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final isArabic = state.isArabic;
        final pendingTasks = state.pendingTasks;
        final completedTasks = state.completedTasks;
        final filter = state.filter;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            title: Text(
              isArabic ? 'Tasks' : 'Tasks',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  _showQuickSettings(context, state);
                },
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 14),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryLight,
                  child: const Icon(Icons.person, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            physics: const BouncingScrollPhysics(),
            children: [
              const DailyMomentumBanner(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        isArabic ? 'مهامي' : 'My Tasks',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurfaceLight,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHighestLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isArabic
                              ? '${state.totalCount} مهام'
                              : '${state.totalCount} tasks',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariantLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildHeaderIconButton(
                        icon: Icons.filter_list,
                        onTap: () {},
                      ),
                      const SizedBox(width: 6),
                      _buildHeaderIconButton(
                        icon: Icons.settings,
                        onTap: () => _showQuickSettings(context, state),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const FilterChipsBar(),
              const SizedBox(height: 16),
              if (filter != TaskFilter.completed) ...[
                ...pendingTasks.map((task) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TaskCard(
                        task: task,
                        isArabic: isArabic,
                        onToggle: () {
                          context.read<TaskBloc>().add(
                                ToggleTaskStatus(
                                  id: task.id,
                                  isCompleted: !task.isCompleted,
                                ),
                              );
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  TaskDetailScreen(existingTask: task),
                            ),
                          );
                        },
                        onDelete: () {
                          context.read<TaskBloc>().add(DeleteTask(task.id));
                        },
                      ),
                    )),
              ],
              if (filter != TaskFilter.pending && completedTasks.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.task_alt,
                      size: 18,
                      color: AppColors.secondaryLight,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isArabic ? 'المهام المنجزة' : 'Completed Tasks',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariantLight,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.surfaceContainerHighestLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...completedTasks.map((task) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TaskCard(
                        task: task,
                        isArabic: isArabic,
                        onToggle: () {
                          context.read<TaskBloc>().add(
                                ToggleTaskStatus(
                                  id: task.id,
                                  isCompleted: !task.isCompleted,
                                ),
                              );
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  TaskDetailScreen(existingTask: task),
                            ),
                          );
                        },
                        onDelete: () {
                          context.read<TaskBloc>().add(DeleteTask(task.id));
                        },
                      ),
                    )),
              ],
              const SizedBox(height: 80),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const TaskDetailScreen(),
                ),
              );
            },
            backgroundColor: AppColors.primaryContainerLight,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.add, size: 28),
          ),
          bottomNavigationBar: TaskBottomNavBar(
            currentIndex: _navIndex,
            isArabic: isArabic,
            onTap: (index) {
              setState(() {
                _navIndex = index;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainerLight,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.onSurfaceVariantLight,
        ),
      ),
    );
  }

  void _showQuickSettings(BuildContext context, TaskState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.isArabic ? 'الإعدادات السريعة' : 'Quick Settings',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(
                  state.isArabic ? 'اللغة / Language' : 'Language / اللغة'),
              subtitle: Text(
                  state.isArabic ? 'العربية (RTL)' : 'English (LTR)'),
              trailing: Switch(
                value: state.isArabic,
                onChanged: (val) {
                  context.read<TaskBloc>().add(
                        SwitchLanguage(Locale(val ? 'ar' : 'en')),
                      );
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
