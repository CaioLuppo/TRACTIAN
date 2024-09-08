import 'package:flutter/material.dart';

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
          const CircularProgressIndicator(),
          const SizedBox(height: 8),
          Text(
            message,
            style: style ?? const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
