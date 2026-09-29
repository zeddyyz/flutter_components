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
  final bool? isIconLeftAligned;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.withValues(alpha: 0.15),
        foregroundColor: Colors.red,
        side: const BorderSide(
          color: Colors.red,
        ),
        enabledMouseCursor: SystemMouseCursors.click,
      ),
      child: child,
    );
  }
}
