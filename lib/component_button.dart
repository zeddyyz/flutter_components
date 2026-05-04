import 'package:flutter/material.dart';
import 'package:flutter_components/components_context_extension.dart';

import 'shared/enums.dart';

class ComponentButton extends StatelessWidget {
  const ComponentButton({
    super.key,
    required this.buttonType,
    required this.child,
    required this.onPressed,
    this.style,
  });

  final ButtonType buttonType;
  final Widget child;
  final VoidCallback onPressed;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    switch (buttonType) {
      case ButtonType.elevated:
        return ElevatedButton(onPressed: onPressed, style: style, child: child);
      case ButtonType.filled:
        return FilledButton(onPressed: onPressed, style: style, child: child);
      case ButtonType.light:
        return OutlinedButton(
          onPressed: onPressed,
          style:
              style ??
              OutlinedButton.styleFrom(
                backgroundColor: context.isLightMode
                    ? Colors.grey.shade300.withValues(alpha: 0.7)
                    : Colors.grey.shade900,
                foregroundColor: context.primary.withValues(alpha: 0.85),
                side: BorderSide(
                  color: context.isLightMode
                      ? Colors.grey.shade300.withValues(alpha: 0.75)
                      : Colors.grey.shade800.withValues(alpha: 0.75),
                ),
              ),
          child: child,
        );
      case ButtonType.outlined:
        return OutlinedButton(onPressed: onPressed, style: style, child: child);
      case ButtonType.text:
        return TextButton(onPressed: onPressed, style: style, child: child);
    }
  }
}
