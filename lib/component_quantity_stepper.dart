import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentQuantityStepper extends StatelessWidget {
  const ComponentQuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    this.step = 1,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;

  @override
  Widget build(BuildContext context) {
    final bool canDecrement = value - step >= min;
    final bool canIncrement = value + step <= max;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: context.componentTheme.chipColor,
        shape: RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusStadium,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            key: const ValueKey<String>('quantity-decrement'),
            icon: Icons.remove_rounded,
            enabled: canDecrement,
            onTap: () => onChanged(value - step),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 36),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: context.body2Heavy,
            ),
          ),
          _StepButton(
            key: const ValueKey<String>('quantity-increment'),
            icon: Icons.add_rounded,
            enabled: canIncrement,
            onTap: () => onChanged(value + step),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.35,
      child: ComponentGestureClick(
        onTap: enabled ? onTap : () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: context.primary),
        ),
      ),
    );
  }
}
