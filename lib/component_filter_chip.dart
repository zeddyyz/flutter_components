import 'package:flutter_components/component_no_splash_theme.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentFilterChip extends StatelessWidget {
  const ComponentFilterChip({
    super.key,
    required this.isSelected,
    required this.label,
    this.labelColor,
    required this.onSelected,
    this.selectedColor,
    this.backgroundColor,
    this.showCheckmark = false,
    this.checkmarkColor,
    this.borderRadius,
    this.borderSide,
    this.padding,
  });

  final bool isSelected;
  final String label;
  final Color? labelColor;
  final Function(bool) onSelected;
  final Color? selectedColor;
  final Color? backgroundColor;
  final bool? showCheckmark;
  final Color? checkmarkColor;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final EdgeInsets? padding;

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
        showCheckmark: showCheckmark ?? false,
        checkmarkColor: checkmarkColor ?? (isSelected ? Colors.white : context.primary),
        shape: RoundedSuperellipseBorder(
          borderRadius: borderRadius ?? AppDecoration.borderRadiusStadium,
          side:
              borderSide ??
              BorderSide(
                color: isSelected ? Colors.transparent : context.borderColorIntense,
              ),
        ),
        padding: padding ?? EdgeInsets.all(10),
      ),
    );
  }
}
