part of '../home_screen.view.dart';

class TryAgainWidget extends StatelessWidget {
  final String message;
  final TextStyle? style;
  final VoidCallback? onTryAgain;

  const TryAgainWidget({
    required this.message,
    this.style,
    this.onTryAgain,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: style ?? const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => onTryAgain?.call(),
            child: const Text(AppStrings.tryAgain),
          ),
        ],
      ),
    );
  }
}
