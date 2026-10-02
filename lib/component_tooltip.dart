import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentTooltip extends StatelessWidget {
  const ComponentTooltip({
    super.key,
    required this.message,
    required this.child,
  });

  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: const Duration(milliseconds: 400),
      decoration: ShapeDecoration(
        color: context.isDarkMode ? const Color(0xFF2C2C2E) : const Color(0xFF1C1C1E),
        shape: RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusMd,
        ),
      ),
      textStyle: context.labelMedium.copyWith(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }
}
