import 'package:material_ui/material_ui.dart';

class ComponentDangerButton extends StatelessWidget {
  const ComponentDangerButton({
    super.key,
    required this.child,
    this.icon,
    this.isIconLeftAligned = true,
    required this.onPressed,
    this.isLoading = false,
  });

  final Widget child;
  final Widget? icon;
  final bool isIconLeftAligned;
  final VoidCallback onPressed;
  final bool isLoading;

  ButtonStyle _style() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.red.withValues(alpha: 0.15),
      foregroundColor: Colors.red,
      side: const BorderSide(
        color: Colors.red,
      ),
      enabledMouseCursor: SystemMouseCursors.click,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: Colors.red,
            ),
          )
        : child;

    if (icon == null || isLoading) {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _style(),
        child: content,
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      style: _style(),
      icon: icon!,
      label: child,
      iconAlignment: isIconLeftAligned ? IconAlignment.start : IconAlignment.end,
    );
  }
}
