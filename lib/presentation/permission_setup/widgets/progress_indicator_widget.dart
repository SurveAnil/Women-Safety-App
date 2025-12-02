import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int totalSteps;
  final int completedSteps;

  const ProgressIndicatorWidget({
    Key? key,
    required this.totalSteps,
    required this.completedSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = completedSteps / totalSteps;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Permission Setup',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '$completedSteps of $totalSteps',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            height: 0.8.h,
            decoration: BoxDecoration(
              color: AppTheme.borderSubtle,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: completedSteps == totalSteps
                      ? AppTheme.successConfirmation
                      : AppTheme.primaryEmergency,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            completedSteps == totalSteps
                ? 'All permissions granted!'
                : 'Grant permissions to continue',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: completedSteps == totalSteps
                  ? AppTheme.successConfirmation
                  : AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
