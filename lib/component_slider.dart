import 'package:flutter_components/component_no_splash_theme.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:material_ui/material_ui.dart';

class ComponentSlider extends StatelessWidget {
  const ComponentSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;

  @override
  Widget build(BuildContext context) {
    final Color active = Theme.of(context).primaryColor;
    return ComponentNoSplashTheme(
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: active,
          inactiveTrackColor: context.componentTheme.chipColor,
          thumbColor: Colors.white,
          overlayColor: active.withValues(alpha: 0.12),
          trackHeight: 4,
        ),
        child: Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
