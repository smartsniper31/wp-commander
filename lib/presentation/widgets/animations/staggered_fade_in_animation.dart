import 'package:flutter/material.dart';

import 'fade_in_animation.dart';

// Variante avec délai
class StaggeredFadeInAnimation extends StatelessWidget {
  final List<Widget> children;
  final Duration delayBetween;
  final Duration itemDuration;

  const StaggeredFadeInAnimation({
    super.key,
    required this.children,
    this.delayBetween = const Duration(milliseconds: 100),
    this.itemDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        return FutureBuilder(
          future: Future.delayed(delayBetween * index),
          builder: (context, snapshot) {
            return FadeInAnimation(
              duration: itemDuration,
              child: child,
            );
          },
        );
      }).toList(),
    );
  }
}
