import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/services/validation_service.dart';
import 'custom_text_field.dart';

class ApiKeyInput extends ConsumerStatefulWidget {
  final String initialValue;
  final void Function(String)? onChanged;
  final String? error;
  final bool showStrength;

  const ApiKeyInput({
    super.key,
    this.initialValue = '',
    this.onChanged,
    this.error,
    this.showStrength = true,
  });

  @override
  ConsumerState<ApiKeyInput> createState() => _ApiKeyInputState();
}

class _ApiKeyInputState extends ConsumerState<ApiKeyInput> {
  late final TextEditingController _controller;
  bool _obscureText = true;
  ApiKeyStrength _strength = ApiKeyStrength.weak;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(ApiKeyInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomTextField(
          label: 'Clé API',
          hint: 'Entrez votre clé API WordPress',
          controller: _controller,
          onChanged: (value) {
            if (widget.showStrength) {
              setState(() {
                _strength = ValidationService.checkApiKeyStrength(value);
              });
            }
            widget.onChanged?.call(value);
          },
          error: widget.error,
          obscureText: _obscureText,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        if (widget.showStrength && _controller.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildStrengthIndicator(theme),
        ],
      ],
    );
  }

  Widget _buildStrengthIndicator(ThemeData theme) {
    Color color;
    switch (_strength) {
      case ApiKeyStrength.weak:
        color = theme.colorScheme.error;
        break;
      case ApiKeyStrength.medium:
        color = theme.colorScheme.primary;
        break;
      case ApiKeyStrength.strong:
        color = theme.colorScheme.tertiary;
        break;
    }

    return Row(
      children: [
        Text(
          'Force: ',
          style: theme.textTheme.bodySmall?.copyWith(
            // ignore: deprecated_member_use
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          _strength.label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          _strength.emoji,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
