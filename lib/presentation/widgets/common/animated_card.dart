import 'package:flutter/material.dart';

import '../animations/fade_in_animation.dart';
import '../animations/slide_in_animation.dart';

class AnimatedCard extends StatelessWidget {
  final Widget child;
  final int index;
  final bool enableAnimation;
  final Duration delay;

  const AnimatedCard({
    super.key,
    required this.child,
    this.index = 0,
    this.enableAnimation = true,
    this.delay = const Duration(milliseconds: 100),
  });

  @override
  Widget build(BuildContext context) {
    if (!enableAnimation) {
      return Card(child: child);
    }

    return FutureBuilder(
      future: Future.delayed(delay * index),
      builder: (context, snapshot) {
        return FadeInAnimation(
          duration: const Duration(milliseconds: 400),
          child: ScaleAnimation(
            duration: const Duration(milliseconds: 300),
            child: Card(child: child),
          ),
        );
      },
    );
  }
}

// Bouton animé
class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;
  final bool enabled;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.enabled = true,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enabled) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.enabled) {
      _controller.reverse();
      widget.onPressed();
    }
  }

  void _onTapCancel() {
    if (widget.enabled) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _animation,
        child: ElevatedButton(
          onPressed: widget.enabled ? () {} : null,
          style: widget.style,
          child: widget.child,
        ),
      ),
    );
  }
}
