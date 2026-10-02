import 'package:flutter_components/components_context_extension.dart';
import 'package:material_ui/material_ui.dart';

class ComponentPageIndicator extends StatelessWidget {
  const ComponentPageIndicator({
    super.key,
    required this.count,
    required this.index,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 7,
    this.spacing = 8,
  }) : assert(count > 0, 'count must be greater than 0');

  final int count;
  final int index;
  final Color? activeColor;
  final Color? inactiveColor;
  final double dotSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final Color active = activeColor ?? context.primary;
    final Color inactive = inactiveColor ?? context.componentTheme.chipColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(width: spacing),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: i == index ? dotSize * 2.2 : dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: i == index ? active : inactive,
              borderRadius: BorderRadius.circular(dotSize),
            ),
          ),
        ],
      ],
    );
  }
}
