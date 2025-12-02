import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QrShareSection extends StatefulWidget {
  const QrShareSection({Key? key}) : super(key: key);

  @override
  State<QrShareSection> createState() => _QrShareSectionState();
}

class _QrShareSectionState extends State<QrShareSection> {
  bool _isGeneratingQr = false;
  bool _isQrGenerated = false;
  String _qrData = '';

  @override
  void initState() {
    super.initState();
    _generateQrCode();
  }

  Future<void> _generateQrCode() async {
    setState(() {
      _isGeneratingQr = true;
    });

    // Simulate QR generation with user data
    await Future.delayed(Duration(milliseconds: 1500));

    final userData = {
      'name': 'Current User',
      'phone': '+1 (555) 000-0000',
      'emergency_contact': true,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    setState(() {
      _qrData = 'safeguard_contact:${userData.toString()}';
      _isQrGenerated = true;
      _isGeneratingQr = false;
    });
  }

  void _shareQrCode() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR code sharing feature will be available soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _copyQrData() {
    Clipboard.setData(ClipboardData(text: _qrData));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact data copied to clipboard'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildQrCodeSection(),
          SizedBox(height: 4.h),
          _buildInstructionsSection(),
          SizedBox(height: 3.h),
          _buildActionButtons(),
          SizedBox(height: 2.h),
          _buildPrivacyNotice(),
        ],
      ),
    );
  }

  Widget _buildQrCodeSection() {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: _isGeneratingQr
          ? _buildLoadingState()
          : _isQrGenerated
              ? _buildQrCodeDisplay()
              : _buildErrorState(),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 15.w,
          height: 15.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Generating QR Code...',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildQrCodeDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // QR Code placeholder with pattern
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: CustomPaint(
            painter: QrPatternPainter(),
            child: Center(
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomIconWidget(
                  iconName: 'security',
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'SafeGuard Contact',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: AppTheme.lightTheme.colorScheme.error,
          size: 48,
        ),
        SizedBox(height: 2.h),
        Text(
          'Failed to generate QR code',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.error,
          ),
        ),
        SizedBox(height: 1.h),
        TextButton(
          onPressed: _generateQrCode,
          child: Text('Try Again'),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'How to use QR Share',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildInstructionStep(
            step: '1',
            title: 'Share your QR code',
            description:
                'Let the other person scan this code with their SafeGuard app',
          ),
          SizedBox(height: 1.5.h),
          _buildInstructionStep(
            step: '2',
            title: 'Mutual contact setup',
            description:
                'Both of you will be added as emergency contacts automatically',
          ),
          SizedBox(height: 1.5.h),
          _buildInstructionStep(
            step: '3',
            title: 'Privacy controls',
            description:
                'You can control what information is shared through the QR code',
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep({
    required String step,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Center(
            child: Text(
              step,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isQrGenerated ? _copyQrData : null,
            icon: CustomIconWidget(
              iconName: 'content_copy',
              color: _isQrGenerated
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            label: Text('Copy Data'),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isQrGenerated ? _shareQrCode : null,
            icon: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 18,
            ),
            label: Text('Share QR'),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'privacy_tip',
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Your privacy is protected. Only basic contact information is shared.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QrPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final cellSize = size.width / 21; // Standard QR code is 21x21 modules

    // Draw a simplified QR pattern
    for (int i = 0; i < 21; i++) {
      for (int j = 0; j < 21; j++) {
        // Create a pattern that looks like QR code
        if (_shouldDrawCell(i, j)) {
          canvas.drawRect(
            Rect.fromLTWH(i * cellSize, j * cellSize, cellSize, cellSize),
            paint,
          );
        }
      }
    }
  }

  bool _shouldDrawCell(int x, int y) {
    // Finder patterns (corners)
    if ((x < 7 && y < 7) || (x >= 14 && y < 7) || (x < 7 && y >= 14)) {
      return _isFinderPattern(x % 7, y % 7);
    }

    // Timing patterns
    if (x == 6 || y == 6) {
      return (x + y) % 2 == 0;
    }

    // Random pattern for data area
    return (x * 3 + y * 5 + x * y) % 7 < 3;
  }

  bool _isFinderPattern(int x, int y) {
    if (x == 0 || x == 6 || y == 0 || y == 6) return true;
    if (x >= 2 && x <= 4 && y >= 2 && y <= 4) return true;
    return false;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
