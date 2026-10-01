import 'package:material_ui/material_ui.dart';

class ComponentDangerButton extends StatelessWidget {
  const ComponentDangerButton({
    super.key,
    required this.child,
    this.icon,
    this.isIconLeftAligned = true,
    required this.onPressed,
  });

  final Widget child;
  final Widget? icon;
  final bool isIconLeftAligned;
  final VoidCallback onPressed;

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
    if (icon == null) {
      return ElevatedButton(
        onPressed: onPressed,
        style: _style(),
        child: child,
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
