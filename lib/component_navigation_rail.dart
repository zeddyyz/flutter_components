import 'package:flutter_components/component_tooltip.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

/// A labeled icon used by [ComponentNavigationRail].
class ComponentNavigationRailDestination {
  const ComponentNavigationRailDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final Widget icon;
  final Widget? selectedIcon;
  final String label;
}

/// Layout of [ComponentNavigationRail].
///
/// Leave [ComponentNavigationRail.mode] null to follow screen size: a compact
/// icon rail up through [AppScreenSize.medium], and an extended labeled
/// sidebar above that.
enum ComponentNavigationRailMode {
  /// Icons only, in an 80px column. Labels are available as tooltips.
  compact,

  /// Icon and label on each row. Width grows from 220px to 260px with the window.
  extended,
}

/// Exposes whether the surrounding [ComponentNavigationRail] is showing labels.
///
/// Read this from a [ComponentNavigationRail.header] or
/// [ComponentNavigationRail.footer] `build` method to swap a logo mark for a
/// logo plus title, or an avatar for an account row.
class ComponentNavigationRailScope extends InheritedWidget {
  const ComponentNavigationRailScope({
    super.key,
    required this.isExtended,
    required super.child,
  });

  final bool isExtended;

  static ComponentNavigationRailScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ComponentNavigationRailScope>();
  }

  static bool isExtendedOf(BuildContext context) {
    final ComponentNavigationRailScope? scope = maybeOf(context);
    assert(
      scope != null,
      'ComponentNavigationRailScope.isExtendedOf must be called from a header '
      'or footer mounted under ComponentNavigationRail',
    );
    return scope!.isExtended;
  }

  @override
  bool updateShouldNotify(ComponentNavigationRailScope oldWidget) {
    return isExtended != oldWidget.isExtended;
  }
}

/// Left-side navigation for tablets and desktops.
///
/// This is only the rail. Place it beside your own navigator shell, for example
/// in a [Row] with the shell as the expanded child. The destination list
/// scrolls between a fixed [header] and [footer]. The rail needs a bounded
/// height, which [CrossAxisAlignment.stretch] provides. On medium screens it is
/// a compact icon rail. On large screens it is an extended sidebar. Set [mode]
/// to force either layout.
class ComponentNavigationRail extends StatelessWidget {
  const ComponentNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.header,
    this.footer,
    this.mode,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<ComponentNavigationRailDestination> destinations;

  /// Pinned at the top. Typically a product mark or wordmark.
  final Widget? header;

  /// Pinned at the bottom. Typically an account row or a utility action.
  final Widget? footer;

  /// Forces [ComponentNavigationRailMode.compact] or
  /// [ComponentNavigationRailMode.extended]. When null, widths through
  /// [AppScreenSize.medium] are compact and wider windows are extended.
  final ComponentNavigationRailMode? mode;

  static const double _compactWidth = 80;
  static const double _extendedWidth = 220;
  // static const double _largeWidth = 240;
  // static const double _xLargeWidth = 260;

  bool _isExtended(BuildContext context) {
    return switch (mode) {
      ComponentNavigationRailMode.compact => false,
      ComponentNavigationRailMode.extended => true,
      null => context.isLargeScreen || context.isXLargeScreen,
    };
  }

  double _widthFor(BuildContext context, bool isExtended) {
    if (!isExtended) {
      return _compactWidth;
    }
    // if (context.isXLargeScreen) {
    //   return _xLargeWidth;
    // }
    // if (context.isLargeScreen) {
    //   return _largeWidth;
    // }
    return _extendedWidth;
  }

  @override
  Widget build(BuildContext context) {
    assert(destinations.isNotEmpty, 'destinations must not be empty');
    assert(
      selectedIndex >= 0 && selectedIndex < destinations.length,
      'selectedIndex $selectedIndex is outside destinations',
    );

    final bool isExtended = _isExtended(context);

    return RepaintBoundary(
      child: SizedBox(
        width: _widthFor(context, isExtended),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: context.borderColor)),
          ),
          child: SafeArea(
            child: ComponentNavigationRailScope(
              isExtended: isExtended,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (header != null)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        isExtended ? 20 : 12,
                        16,
                        isExtended ? 20 : 12,
                        8,
                      ),
                      child: isExtended ? header! : Center(child: header!),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        isExtended ? 12 : 0,
                        8,
                        isExtended ? 12 : 0,
                        16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int index = 0; index < destinations.length; index++)
                            _RailDestinationButton(
                              index: index,
                              destination: destinations[index],
                              isSelected: index == selectedIndex,
                              isExtended: isExtended,
                              onDestinationSelected: onDestinationSelected,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (footer != null)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: context.borderColor),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: isExtended ? footer! : Center(child: footer!),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RailDestinationButton extends StatefulWidget {
  const _RailDestinationButton({
    required this.index,
    required this.destination,
    required this.isSelected,
    required this.isExtended,
    required this.onDestinationSelected,
  });

  final int index;
  final ComponentNavigationRailDestination destination;
  final bool isSelected;
  final bool isExtended;
  final ValueChanged<int> onDestinationSelected;

  @override
  State<_RailDestinationButton> createState() => _RailDestinationButtonState();
}

class _RailDestinationButtonState extends State<_RailDestinationButton> {
  bool _hovered = false;

  Color _backgroundColor(BuildContext context) {
    final Color chip = context.chipColor;
    if (widget.isSelected) {
      return chip;
    }
    if (_hovered) {
      return chip.withValues(
        alpha: context.isLightMode ? 0.35 : 0.55,
      );
    }
    return chip.withValues(alpha: 0);
  }

  @override
  Widget build(BuildContext context) {
    final bool isExtended = widget.isExtended;
    final Widget icon = _RailDestinationIcon(
      destination: widget.destination,
      isSelected: widget.isSelected,
      size: isExtended ? 22 : 24,
    );

    final Widget visual = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: isExtended ? null : 48,
      height: isExtended ? null : 48,
      alignment: isExtended ? null : Alignment.center,
      padding: isExtended ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12) : null,
      decoration: ShapeDecoration(
        color: _backgroundColor(context),
        shape: const RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusLg,
        ),
      ),
      child: isExtended
          ? Row(
              spacing: 12,
              children: [
                icon,
                Expanded(
                  child: Text(
                    widget.destination.label,
                    style: (widget.isSelected ? context.bodyHeavy : context.bodyMedium).copyWith(
                      color: widget.isSelected ? context.primary : context.hintIntense,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
          : icon,
    );

    Widget button = ComponentGestureClick(
      key: ValueKey<String>('nav-dest-${widget.index}'),
      semanticsLabel: widget.destination.label,
      selected: widget.isSelected,
      onTap: () => widget.onDestinationSelected(widget.index),
      child: ExcludeSemantics(child: visual),
    );

    if (!isExtended) {
      button = ComponentTooltip(
        message: widget.destination.label,
        child: button,
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isExtended ? 2 : 4),
        child: isExtended ? button : Center(child: button),
      ),
    );
  }
}

class _RailDestinationIcon extends StatelessWidget {
  const _RailDestinationIcon({
    required this.destination,
    required this.isSelected,
    required this.size,
  });

  final ComponentNavigationRailDestination destination;
  final bool isSelected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        size: size,
        color: isSelected ? context.primary : context.hintIntense,
      ),
      child: isSelected ? (destination.selectedIcon ?? destination.icon) : destination.icon,
    );
  }
}
