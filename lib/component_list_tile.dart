import 'package:flutter/material.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

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
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsets? contentPadding;
  final bool displayBorder;

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
    // Create a theme-dependent key to ensure proper rebuilds
    final themeKey = ValueKey('${Theme.of(context).brightness}_${widget.isWithinBottomSheet}');

    return AnimatedContainer(
      key: themeKey,
      duration: const Duration(milliseconds: 100),
      child: Builder(
        builder: (builderContext) {
          // Calculate theme-dependent values
          final tileColor = widget.isWithinBottomSheet ? null : context.cardColor;

          final borderColor = widget.isSelected
              ? (widget.isSelectedColor ?? builderContext.borderColor)
              : (widget.isWithinBottomSheet
                    ? builderContext.borderColorIntense
                    : Colors.transparent);

          final contentPadding =
              widget.contentPadding ??
              EdgeInsets.symmetric(
                horizontal: 16,
                vertical: switch (widget.subtitle) {
                  null => builderContext.isMobile ? 0 : 8,
                  _ => builderContext.isMobile ? 10 : 14,
                },
              );

          final titleStyle = widget.titleStyle ?? Theme.of(builderContext).textTheme.bodySmall;
          final subtitleStyle =
              widget.subtitleStyle ??
              Theme.of(builderContext).textTheme.labelSmall!.copyWith(color: builderContext.hint);

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              decoration: ShapeDecoration(
                color: tileColor,
                shape: RoundedSuperellipseBorder(
                  borderRadius: AppDecoration.borderRadiusSm,
                  side: widget.displayBorder ? BorderSide(color: borderColor) : BorderSide.none,
                ),
              ),
              child: ListTile(
                leading: widget.leading,
                title: widget.title,
                subtitle: widget.subtitle,
                trailing: widget.trailing,
                tileColor: tileColor,
                shape: RoundedSuperellipseBorder(
                  borderRadius: AppDecoration.borderRadiusSm,
                ),
                contentPadding: contentPadding,
                titleTextStyle: titleStyle,
                subtitleTextStyle: subtitleStyle,
                onTap: widget.onTap,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
              ),
            ),
          );
        },
      ),
    );
  }
}
