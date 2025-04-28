import 'package:flutter/material.dart';
import '../../constants/theme_constants.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            size: 48,
            color: ThemeConstants.errorColor,
          ),
          SizedBox(height: ThemeConstants.spacingMedium),
          Text(
            message,
            style: ThemeConstants.bodyStyle,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: ThemeConstants.spacingLarge),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.borderRadiusMedium,
                  ),
                ),
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ],
      ),
    );
  }
} 