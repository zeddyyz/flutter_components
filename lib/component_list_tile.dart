import 'package:flutter_components/component_checkbox.dart';
import 'package:flutter_components/component_no_splash_theme.dart';
import 'package:flutter_components/component_switch.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentListTile extends StatefulWidget {
  const ComponentListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.isSelectedColor,
    this.isWithinBottomSheet = false,
    this.titleStyle,
    this.subtitleStyle,
    this.contentPadding,
    this.displayBorder = false,
    this.borderRadius,
    this.backgroundColor,
    this.showChevron = false,
    this.switchValue,
    this.onSwitchChanged,
    this.checkboxValue,
    this.onCheckboxChanged,
  });

  const ComponentListTile.chevron({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isSelected = false,
    this.isSelectedColor,
    this.isWithinBottomSheet = false,
    this.titleStyle,
    this.subtitleStyle,
    this.contentPadding,
    this.displayBorder = false,
    this.borderRadius,
    this.backgroundColor,
  }) : trailing = null,
       showChevron = true,
       switchValue = null,
       onSwitchChanged = null,
       checkboxValue = null,
       onCheckboxChanged = null;

  const ComponentListTile.switchTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    this.isSelected = false,
    this.isSelectedColor,
    this.isWithinBottomSheet = false,
    this.titleStyle,
    this.subtitleStyle,
    this.contentPadding,
    this.displayBorder = false,
    this.borderRadius,
    this.backgroundColor,
  }) : trailing = null,
       showChevron = false,
       switchValue = value,
       onSwitchChanged = onChanged,
       checkboxValue = null,
       onCheckboxChanged = null,
       onTap = null;

  const ComponentListTile.checkboxTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    this.isSelected = false,
    this.isSelectedColor,
    this.isWithinBottomSheet = false,
    this.titleStyle,
    this.subtitleStyle,
    this.contentPadding,
    this.displayBorder = false,
    this.borderRadius,
    this.backgroundColor,
  }) : trailing = null,
       showChevron = false,
       switchValue = null,
       onSwitchChanged = null,
       checkboxValue = value,
       onCheckboxChanged = onChanged,
       onTap = null;

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsets? contentPadding;
  final bool displayBorder;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final bool showChevron;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final bool? checkboxValue;
  final ValueChanged<bool>? onCheckboxChanged;

  /// A modern list tile with a leading icon, title, subtitle, and trailing icon.
  /// The leading icon is optional, and the title is required.
  /// The subtitle and trailing icon are also optional.
  /// The onTap callback is optional and can be used to handle tap events.
  /// The tile color is set to the card color of the current context.
  /// The shape of the tile is a rounded rectangle with a medium border radius.
  /// The content padding is set based on the presence of the subtitle and the device type (mobile or not).
  ///
  ///
  final bool isSelected;
  final Color? isSelectedColor;
  final bool isWithinBottomSheet;

  @override
  State<ComponentListTile> createState() => _ComponentListTileState();
}

class _ComponentListTileState extends State<ComponentListTile> {
  @override
  Widget build(BuildContext context) {
    // Theme-dependent key so the tile rebuilds with the sheet/brightness. Not a
    // [ValueKey<String>] — those are reserved for agent-driving hit targets.
    final themeKey = ValueKey((Theme.of(context).brightness, widget.isWithinBottomSheet));

    return AnimatedContainer(
      key: themeKey,
      duration: const Duration(milliseconds: 100),
      child: Builder(
        builder: (builderContext) {
          // Calculate theme-dependent values
          final tileColor =
              widget.backgroundColor ??
              (widget.isWithinBottomSheet ? context.bottomSheetCardColor : context.cardColor);

          final borderColor = widget.isSelected
              ? (widget.isSelectedColor ??
                    (widget.isWithinBottomSheet
                        ? builderContext.borderColorIntense
                        : builderContext.borderColor))
              : Colors.transparent;

          final contentPadding =
              widget.contentPadding ??
              EdgeInsets.symmetric(
                horizontal: 16,
                vertical: switch (widget.subtitle) {
                  null => builderContext.isMobile ? 0 : 8,
                  _ => builderContext.isMobile ? 10 : 14,
                },
              );

          final titleStyle = widget.titleStyle ?? builderContext.textTheme.bodySmall;
          final subtitleStyle =
              widget.subtitleStyle ??
              builderContext.textTheme.labelSmall!.copyWith(color: builderContext.hint);

          return ComponentNoSplashTheme(
            child: ListTile(
              leading: widget.leading,
              title: widget.title,
              subtitle: widget.subtitle,
              trailing: _buildTrailing(builderContext),
              tileColor: tileColor,
              shape: RoundedSuperellipseBorder(
                borderRadius: widget.borderRadius ?? AppDecoration.borderRadiusCard,
                side: widget.displayBorder ? BorderSide(color: borderColor) : BorderSide.none,
              ),
              contentPadding: contentPadding,
              titleTextStyle: titleStyle,
              subtitleTextStyle: subtitleStyle,
              onTap: _tileTap,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              mouseCursor: _tileTap != null
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.none,
            ),
          );
        },
      ),
    );
  }

  VoidCallback? get _tileTap {
    if (widget.onTap != null) return widget.onTap;
    if (widget.onSwitchChanged != null) {
      return () => widget.onSwitchChanged!(!widget.switchValue!);
    }
    if (widget.onCheckboxChanged != null) {
      return () => widget.onCheckboxChanged!(!widget.checkboxValue!);
    }
    return null;
  }

  Widget? _buildTrailing(BuildContext context) {
    if (widget.switchValue != null) {
      return ComponentSwitch(
        value: widget.switchValue!,
        onChanged: widget.onSwitchChanged,
      );
    }
    if (widget.checkboxValue != null) {
      return ComponentCheckbox(
        value: widget.checkboxValue!,
        onChanged: widget.onCheckboxChanged,
      );
    }
    if (widget.trailing != null) return widget.trailing;
    if (widget.showChevron) {
      return Icon(Icons.chevron_right_rounded, color: context.hint);
    }
    return null;
  }
}
