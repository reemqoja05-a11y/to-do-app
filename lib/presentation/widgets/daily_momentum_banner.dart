import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_state.dart';

class DailyMomentumBanner extends StatelessWidget {
  const DailyMomentumBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final isArabic = state.isArabic;
        final percent = state.completionPercentage;
        final ratio = state.completionRatio;
        final completed = state.completedCount;
        final total = state.totalCount;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: isArabic ? -20 : null,
                right: isArabic ? null : -20,
                bottom: -20,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryFixedDimLight.withOpacity(0.25),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: AppColors.secondaryLight,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isArabic ? 'أداء رائع اليوم!' : 'Daily Momentum',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isArabic ? 'يومك منظم وواضح' : 'Stay on Track',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isArabic
                              ? 'أنجزت $completed مهام من أصل $total، استمر بالعطاء.'
                              : '$completed of $total completed · Keep going!',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariantLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: ratio,
                          strokeWidth: 4.5,
                          backgroundColor:
                              AppColors.outlineVariantLight.withOpacity(0.4),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primaryLight,
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                        Center(
                          child: Text(
                            isArabic ? '%$percent' : '$percent%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
