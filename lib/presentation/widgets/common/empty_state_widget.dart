import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmptyStateWidget extends ConsumerWidget {
  final String title;
  final String description;
  final String? assetPath;
  final IconData? icon;
  final List<EmptyStateAction> actions;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.assetPath,
    this.icon,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetPath != null) ...[
              Image.asset(
                assetPath!,
                width: 120,
                height: 120,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: 64,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 24),
              ...actions.map((action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: action.isPrimary
                      ? FilledButton(
                          onPressed: action.onPressed,
                          child: Text(action.label),
                        )
                      : OutlinedButton(
                          onPressed: action.onPressed,
                          child: Text(action.label),
                        ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyStateAction {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const EmptyStateAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });
}
