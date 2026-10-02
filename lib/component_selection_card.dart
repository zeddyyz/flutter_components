import 'package:dynamic_grid_view/dynamic_grid_view.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

/// A tappable choice card. The parent owns selection, so the same widget
/// covers single-select, multi-select, and on/off.
class ComponentSelectionCard extends StatelessWidget {
  const ComponentSelectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
    this.accent,
    this.subtitle,
    this.footer,
    this.backgroundColor,
  });

  final Widget icon;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;
  final Color? accent;
  final Widget? footer;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final Color resolvedAccent = accent ?? Theme.of(context).primaryColor;

    return RepaintBoundary(
      child: Semantics(
        button: true,
        selected: selected,
        label: title,
        child: ComponentGestureClick(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: ShapeDecoration(
              color: selected
                  ? resolvedAccent.withValues(alpha: context.isLightMode ? 0.08 : 0.16)
                  : backgroundColor != null
                  ? backgroundColor!
                  : context.cardColor,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppDecoration.borderRadiusCard,
                side: BorderSide(
                  color: selected ? resolvedAccent : Colors.transparent,
                  width: 1.6,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _TintedIcon(icon: icon, color: resolvedAccent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: context.bodyHeavy,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: context.bodyLight.copyWith(
                                color: context.hintIntenseIos,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _SelectionCheck(selected: selected, accent: resolvedAccent),
                  ],
                ),
                if (footer != null) ...[
                  const SizedBox(height: 12),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ComponentSelectionOption<T> {
  const ComponentSelectionOption({
    required this.value,
    required this.icon,
    required this.title,
    this.subtitle,
    this.accent,
    this.footer,
  });

  final T value;
  final Widget icon;
  final String title;
  final String? subtitle;
  final Color? accent;
  final Widget? footer;
}

/// Lays [ComponentSelectionCard]s out in a grid for single- or multi-select.
class ComponentSelectionGroup<T> extends StatelessWidget {
  const ComponentSelectionGroup({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.crossAxisCount,
    this.backgroundColor,
  }) : values = null,
       onValuesChanged = null,
       _allowMultiple = false;

  const ComponentSelectionGroup.multi({
    super.key,
    required this.options,
    required Set<T> this.values,
    required ValueChanged<Set<T>> this.onValuesChanged,
    this.crossAxisCount,
    this.backgroundColor,
  }) : value = null,
       onChanged = null,
       _allowMultiple = true;

  final List<ComponentSelectionOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final Set<T>? values;
  final ValueChanged<Set<T>>? onValuesChanged;
  final int? crossAxisCount;
  final bool _allowMultiple;
  final Color? backgroundColor;

  bool _isSelected(T optionValue) {
    if (_allowMultiple) return values!.contains(optionValue);
    return optionValue == value;
  }

  void _onTap(T optionValue) {
    if (!_allowMultiple) {
      onChanged!(optionValue);
      return;
    }

    final Set<T> next = Set<T>.of(values!);
    if (!next.add(optionValue)) next.remove(optionValue);
    onValuesChanged!(next);
  }

  @override
  Widget build(BuildContext context) {
    return DynamicGridView(
      itemCount: options.length,
      crossAxisCount: crossAxisCount ?? context.gridViewCrossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      builder: (BuildContext context, int index) {
        final ComponentSelectionOption<T> option = options[index];
        return ComponentSelectionCard(
          key: ValueKey<String>('selection-card-${option.value}'),
          icon: option.icon,
          title: option.title,
          subtitle: option.subtitle,
          accent: option.accent,
          footer: option.footer,
          selected: _isSelected(option.value),
          onTap: () => _onTap(option.value),
          backgroundColor: backgroundColor,
        );
      },
    );
  }
}

class _TintedIcon extends StatelessWidget {
  const _TintedIcon({required this.icon, required this.color});

  final Widget icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusLg,
        ),
      ),
      child: IconTheme(
        data: IconThemeData(color: color, size: 20),
        child: icon,
      ),
    );
  }
}

class _SelectionCheck extends StatelessWidget {
  const _SelectionCheck({required this.selected, required this.accent});

  final bool selected;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) => ScaleTransition(
        scale: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: selected
          ? Icon(
              Icons.check_circle_rounded,
              key: const ValueKey<bool>(true),
              size: 24,
              color: accent,
            )
          : Icon(
              Icons.circle_outlined,
              key: const ValueKey<bool>(false),
              size: 24,
              color: context.borderColorIntense,
            ),
    );
  }
}
