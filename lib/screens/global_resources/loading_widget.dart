import 'package:flutter/material.dart';
import 'package:tractian/src/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  final String message;
  final TextStyle? style;

  const LoadingWidget({
    required this.message,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppTheme.getScheme().secondary),
          const SizedBox(height: 16),
          Text(
            message,
            style: style ?? const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
