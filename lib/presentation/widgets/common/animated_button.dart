import 'package:flutter/material.dart';

import '../common/loading_indicator.dart';

class AnimatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool enabled;
  final Duration duration;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      child: enabled
          ? FilledButton(
              onPressed: onPressed,
              child: child,
            )
          : const FilledButton(
              onPressed: null,
              child: ButtonLoadingIndicator(),
            ),
    );
  }
}
