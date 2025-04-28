import 'package:flutter/material.dart';
import '../../constants/theme_constants.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;

  const LoadingIndicator({
    super.key,
    this.message,
    this.color,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color ?? ThemeConstants.primaryColor,
              strokeWidth: 3.0,
            ),
          ),
          if (message != null) ...[
            SizedBox(height: ThemeConstants.spacingMedium),
            Text(
              message!,
              style: ThemeConstants.bodyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
} 