import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class TaskBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isArabic;
  final ValueChanged<int> onTap;

  const TaskBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLight.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.check_circle_outline,
                    activeIcon: Icons.check_circle,
                    label: isArabic ? 'المهام' : 'Tasks',
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.calendar_today_outlined,
                    activeIcon: Icons.calendar_today,
                    label: isArabic ? 'اليوم' : 'Today',
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: Icons.folder_outlined,
                    activeIcon: Icons.folder,
                    label: isArabic ? 'المشاريع' : 'Projects',
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.account_circle_outlined,
                    activeIcon: Icons.account_circle,
                    label: isArabic ? 'حسابي' : 'You',
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                width: 120,
                height: 4,
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: AppColors.outlineVariantLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryContainerLight
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected
                  ? AppColors.onSecondaryContainerLight
                  : AppColors.onSurfaceVariantLight,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
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
