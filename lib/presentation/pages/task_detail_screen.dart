import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/task_model.dart';
import '../../presentation/bloc/task_bloc.dart';
import '../../presentation/bloc/task_event.dart';
import '../../presentation/bloc/task_state.dart';
import '../../presentation/widgets/delete_task_dialog.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task? existingTask;

  const TaskDetailScreen({super.key, this.existingTask});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  TaskPriority _selectedPriority = TaskPriority.urgent;
  TaskCategory _selectedCategory = TaskCategory.work;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _dueTime = const TimeOfDay(hour: 10, minute: 0);
  bool _hasAttemptedSubmit = false;
  bool _isTitleInvalid = false;

  bool get isEditMode => widget.existingTask != null;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingTask?.title ?? '');
    _descController =
        TextEditingController(text: widget.existingTask?.description ?? '');

    if (widget.existingTask != null) {
      _selectedPriority = widget.existingTask!.priority;
      _selectedCategory = widget.existingTask!.category;
    }

    _titleController.addListener(() {
      if (_hasAttemptedSubmit) {
        setState(() {
          _isTitleInvalid = _titleController.text.trim().isEmpty;
        });
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTask() {
    setState(() {
      _hasAttemptedSubmit = true;
      _isTitleInvalid = _titleController.text.trim().isEmpty;
    });

    if (_isTitleInvalid) {
      return;
    }

    final state = context.read<TaskBloc>().state;
    final isArabic = state.isArabic;
    final timeFormatted =
        '${_dueTime.hour > 12 ? _dueTime.hour - 12 : _dueTime.hour}:${_dueTime.minute.toString().padLeft(2, '0')} ${_dueTime.period == DayPeriod.am ? (isArabic ? 'ص' : 'AM') : (isArabic ? 'م' : 'PM')}';

    final dueText = isArabic ? 'غداً، $timeFormatted' : 'Tomorrow, $timeFormatted';

    if (isEditMode) {
      final updated = widget.existingTask!.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        dueDateTime: dueText,
        priority: _selectedPriority,
        category: _selectedCategory,
      );
      context.read<TaskBloc>().add(UpdateTask(updated));
    } else {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        dueDateTime: dueText,
        dueDate: _dueDate,
        priority: _selectedPriority,
        category: _selectedCategory,
        subtasksCompleted: 1,
        subtasksTotal: 3,
      );
      context.read<TaskBloc>().add(AddTask(newTask));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state.status == TaskStatus.success) {
          final isArabic = state.isArabic;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.secondaryContainerLight),
                  const SizedBox(width: 8),
                  Text(isArabic
                      ? 'تم حفظ المهمة بنجاح'
                      : 'Task saved successfully'),
                ],
              ),
              action: SnackBarAction(
                label: isArabic ? 'تراجع' : 'Undo',
                textColor: AppColors.primaryFixedDimLight,
                onPressed: () {},
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: const Color(0xFF313034),
            ),
          );
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          final isArabic = state.isArabic;

          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                isArabic ? 'تفاصيل المهمة' : 'Task Details',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 14),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primaryLight,
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.secondaryContainerLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_calendar,
                            color: AppColors.onSecondaryContainerLight,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic
                                    ? 'روتين أو هدف جديد'
                                    : 'New Routine or Goal',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurfaceLight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isArabic
                                    ? 'حافظ على تركيزك وتنظيم أولوياتك اليومية'
                                    : 'Stay organized with focused priorities',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariantLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: isArabic ? 'عنوان المهمة ' : 'Task Title ',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _isTitleInvalid
                                ? AppColors.errorLight
                                : AppColors.onSurfaceVariantLight,
                          ),
                          children: const [
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: AppColors.errorLight),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${_titleController.text.length}/60',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariantLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: _isTitleInvalid
                          ? AppColors.errorContainerLight.withOpacity(0.35)
                          : AppColors.surfaceContainerHighLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isTitleInvalid
                            ? AppColors.errorLight
                            : Colors.transparent,
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 60,
                            buildCounter: (ctx,
                                    {currentLength = 0,
                                    isFocused = false,
                                    maxLength}) =>
                                null,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onSurfaceLight,
                            ),
                            decoration: InputDecoration(
                              hintText: isArabic
                                  ? 'مثال: إعداد مراجعة المشروع الفصلية'
                                  : 'e.g. Prepare design sprint deck',
                              hintStyle: TextStyle(
                                color: AppColors.onSurfaceVariantLight
                                    .withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_isTitleInvalid)
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.errorLight,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                  if (_isTitleInvalid) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.info_outline,
                            size: 14, color: AppColors.errorLight),
                        const SizedBox(width: 4),
                        Text(
                          isArabic
                              ? 'عنوان المهمة مطلوب. يرجى إدخال اسم واضح للمهمة.'
                              : 'Title is required. Please provide a clear task name.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.errorLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 18),
                  Text(
                    isArabic
                        ? 'التفاصيل والملاحظات (اختياري)'
                        : 'Description (optional)',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariantLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    child: TextField(
                      controller: _descController,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceLight,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        hintText: isArabic
                            ? 'أضف التفاصيل، الملاحظات، الروابط أو معايير القبول...'
                            : 'Add details, notes, links or acceptance criteria...',
                        hintStyle: TextStyle(
                          color:
                              AppColors.onSurfaceVariantLight.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isArabic
                            ? 'يدعم تنسيق Markdown'
                            : 'Markdown shortcuts supported',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariantLight),
                      ),
                      Text(
                        isArabic ? 'حفظ تلقائي محلي' : 'Auto-saved locally',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariantLight),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    isArabic ? 'تاريخ ووقت الاستحقاق' : 'Due Date & Time',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariantLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _dueTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _dueDate = pickedDate;
                            _dueTime = pickedTime;
                          });
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHighLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: AppColors.primaryLight,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isArabic
                                      ? 'غداً، ١٠:٠٠ ص'
                                      : 'Tomorrow, 10:00 AM',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurfaceLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isArabic
                                      ? 'تذكير قبل ١٥ دقيقة'
                                      : 'Reminder set 15m prior',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.onSurfaceVariantLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            color: AppColors.onSurfaceVariantLight,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isArabic ? 'الأولوية والتصنيف' : 'Priority & Tag',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariantLight,
                        ),
                      ),
                      Text(
                        isArabic ? 'اختر واحداً' : 'Select one',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildPriorityChip(
                        label: isArabic ? 'عاجل' : 'Urgent',
                        priority: TaskPriority.urgent,
                      ),
                      _buildCategoryChip(
                        label: isArabic ? 'عمل' : 'Work',
                        category: TaskCategory.work,
                      ),
                      _buildCategoryChip(
                        label: isArabic ? 'شخصي' : 'Personal',
                        category: TaskCategory.personal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowestLight,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryFixedLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.primaryLight,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isArabic
                                ? 'إضافة التصنيفات ومواعيد الاستحقاق ترفع نسبة إنجاز المهام في موعدها بنسبة ٤٢٪.'
                                : 'Adding tags and deadlines boosts on-time task completion by 42%.',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariantLight,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => _saveTask(),
                      icon: Icon(
                        isEditMode ? Icons.save : Icons.add_task,
                        size: 20,
                      ),
                      label: Text(
                        isEditMode
                            ? (isArabic ? 'حفظ التعديلات' : 'Save Changes')
                            : (isArabic ? 'إضافة المهمة' : 'Add Task'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        if (isEditMode) {
                          DeleteTaskDialog.show(
                            context,
                            task: widget.existingTask!,
                            isArabic: isArabic,
                            onConfirm: () {
                              context
                                  .read<TaskBloc>()
                                  .add(DeleteTask(widget.existingTask!.id));
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.delete_outline,
                          size: 18, color: AppColors.errorLight),
                      label: Text(
                        isArabic
                            ? (isEditMode
                                ? 'حذف المهمة'
                                : 'إلغاء وحذف المسودة')
                            : (isEditMode
                                ? 'Delete Task'
                                : 'Delete draft task'),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.errorLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriorityChip({
    required String label,
    required TaskPriority priority,
  }) {
    final isSelected = _selectedPriority == priority;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        setState(() {
          _selectedPriority = priority;
        });
      },
      selectedColor: AppColors.secondaryContainerLight,
      backgroundColor: AppColors.surfaceContainerHighLight,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected
            ? AppColors.onSecondaryContainerLight
            : AppColors.onSurfaceVariantLight,
      ),
      avatar: isSelected
          ? const Icon(Icons.check,
              size: 16, color: AppColors.onSecondaryContainerLight)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required TaskCategory category,
  }) {
    final isSelected = _selectedCategory == category;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        setState(() {
          _selectedCategory = category;
        });
      },
      selectedColor: AppColors.secondaryContainerLight,
      backgroundColor: AppColors.surfaceContainerHighLight,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected
            ? AppColors.onSecondaryContainerLight
            : AppColors.onSurfaceVariantLight,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
