import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorRetryWidget extends ConsumerWidget {
  final String message;
  final String? details;
  final VoidCallback onRetry;
  final String retryText;

  const ErrorRetryWidget({
    super.key,
    required this.message,
    this.details,
    required this.onRetry,
    this.retryText = 'Réessayer', required String title, required String description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: onRetry,
              child: Text(retryText),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget d'erreur avec actions multiples
class ErrorActionsWidget extends StatelessWidget {
  final String title;
  final String message;
  final List<ErrorAction> actions;

  const ErrorActionsWidget({
    super.key,
    required this.title,
    required this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: actions.map((action) {
        return TextButton(
          onPressed: action.onPressed,
          child: Text(action.label),
        );
      }).toList(),
    );
  }
}

class ErrorAction {
  final String label;
  final VoidCallback onPressed;

  const ErrorAction({
    required this.label,
    required this.onPressed,
  });
}
