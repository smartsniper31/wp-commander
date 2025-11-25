import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/ui/app_ui_provider.dart';

class GlobalLoadingOverlay extends ConsumerWidget {
  final Widget child;

  const GlobalLoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    final loadingMessage = ref.watch(loadingMessageProvider);

    return Stack(
      children: [
        child,
        if (isLoading) ...[
          // Overlay semi-transparent
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Indicateur de loading central
          Center(
            child: _buildLoadingDialog(context, loadingMessage),
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingDialog(BuildContext context, String? message) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
