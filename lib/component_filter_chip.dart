import 'package:flutter/material.dart';
import 'package:flutter_components/component_no_splash_theme.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

class ComponentFilterChip extends StatelessWidget {
  const ComponentFilterChip({
    super.key,
    required this.isSelected,
    required this.label,
    this.labelColor,
    required this.onSelected,
    this.selectedColor,
    this.backgroundColor,
    this.checkmarkColor,
    this.borderRadius,
    this.borderSide,
  });

  final bool isSelected;
  final String label;
  final Color? labelColor;
  final Function(bool) onSelected;
  final Color? selectedColor;
  final Color? backgroundColor;
  final Color? checkmarkColor;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    Color bgColor =
        backgroundColor ?? (context.isLightMode ? Colors.grey.shade100 : Colors.grey.shade900);

    return ComponentNoSplashTheme(
      child: FilterChip(
        label: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: labelColor ?? (isSelected ? Colors.white : context.primary),
          ),
        ),
        selected: isSelected,
        onSelected: onSelected,
        selectedColor: selectedColor,
        backgroundColor: bgColor,
        checkmarkColor: checkmarkColor ?? (isSelected ? Colors.white : context.primary),
        shape: RoundedSuperellipseBorder(
          borderRadius: borderRadius ?? AppDecoration.borderRadiusSm,
          side:
              borderSide ??
              BorderSide(
                color: isSelected ? Colors.transparent : context.borderColorIntense,
              ),
        ),
      ),
    );
  }
}
