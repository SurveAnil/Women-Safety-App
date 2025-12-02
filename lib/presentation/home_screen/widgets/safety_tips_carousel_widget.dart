import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SafetyTipsCarouselWidget extends StatefulWidget {
  const SafetyTipsCarouselWidget({Key? key}) : super(key: key);

  @override
  State<SafetyTipsCarouselWidget> createState() =>
      _SafetyTipsCarouselWidgetState();
}

class _SafetyTipsCarouselWidgetState extends State<SafetyTipsCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> safetyTips = [
    {
      "icon": "security",
      "title": "Trust Your Instincts",
      "description":
          "If something feels wrong, it probably is. Don't ignore your gut feelings about people or situations.",
      "color": AppTheme.primaryEmergency,
    },
    {
      "icon": "location_on",
      "title": "Share Your Location",
      "description":
          "Always let trusted contacts know where you're going and when you expect to return.",
      "color": AppTheme.successConfirmation,
    },
    {
      "icon": "phone",
      "title": "Keep Phone Charged",
      "description":
          "Maintain at least 20% battery and consider carrying a portable charger for emergencies.",
      "color": AppTheme.warningAccent,
    },
    {
      "icon": "group",
      "title": "Stay in Groups",
      "description":
          "When possible, travel with friends or stay in well-populated, well-lit areas.",
      "color": AppTheme.primaryEmergency,
    },
    {
      "icon": "fitness_center",
      "title": "Practice Self-Defense",
      "description":
          "Learn basic self-defense techniques and practice them regularly to build muscle memory.",
      "color": AppTheme.successConfirmation,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            'Safety Tips',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: safetyTips.length,
            itemBuilder: (context, index) {
              final tip = safetyTips[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (tip["color"] as Color).withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color:
                                (tip["color"] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: tip["icon"] as String,
                            color: tip["color"] as Color,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            tip["title"] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: Text(
                        tip["description"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            safetyTips.length,
            (index) => Container(
              width: _currentIndex == index ? 8.w : 2.w,
              height: 1.h,
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppTheme.primaryEmergency
                    : AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
