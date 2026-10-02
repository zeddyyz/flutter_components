import 'package:flutter_components/component_bottom_nav_bar.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

/// A labeled icon used by [ComponentAdaptiveNavigation].
class ComponentNavigationDestination {
  const ComponentNavigationDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final Widget icon;
  final Widget? selectedIcon;
  final String label;
}

/// Switches between a mobile bottom-nav island and a persistent labeled
/// sidebar on medium and larger screens. The body always takes remaining space.
class ComponentAdaptiveNavigation extends StatelessWidget {
  const ComponentAdaptiveNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.leading,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<ComponentNavigationDestination> destinations;
  final Widget body;

  /// Sidebar header (logo, title). Shown on medium and larger screens only.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    assert(destinations.isNotEmpty, 'destinations must not be empty');
    assert(
      selectedIndex >= 0 && selectedIndex < destinations.length,
      'selectedIndex $selectedIndex is outside destinations',
    );

    if (context.isMobile) {
      return _MobileNavigationShell(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
        body: body,
      );
    }

    return _SidebarNavigationShell(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations,
      body: body,
      leading: leading,
    );
  }
}

class _MobileNavigationShell extends StatelessWidget {
  const _MobileNavigationShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<ComponentNavigationDestination> destinations;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: body),
        ComponentBottomNavBar(
          childrenCenterAligned: [
            for (int index = 0; index < destinations.length; index++)
              _DestinationButton(
                index: index,
                destination: destinations[index],
                isSelected: index == selectedIndex,
                iconSize: 32,
                onDestinationSelected: onDestinationSelected,
              ),
          ],
        ),
      ],
    );
  }
}

class _SidebarNavigationShell extends StatelessWidget {
  const _SidebarNavigationShell({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.leading,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<ComponentNavigationDestination> destinations;
  final Widget body;
  final Widget? leading;

  static double _sidebarWidthFor(BuildContext context) {
    if (context.isXLargeScreen) {
      return 260;
    }
    if (context.isLargeScreen) {
      return 240;
    }
    return 220;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RepaintBoundary(
          child: SizedBox(
            key: const ValueKey<String>('adaptive-nav-sidebar'),
            width: _sidebarWidthFor(context),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: context.borderColor),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (leading != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: leading,
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                        child: Column(
                          children: [
                            for (int index = 0; index < destinations.length; index++)
                              _SidebarDestinationButton(
                                index: index,
                                destination: destinations[index],
                                isSelected: index == selectedIndex,
                                onDestinationSelected: onDestinationSelected,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(child: body),
      ],
    );
  }
}

class _SidebarDestinationButton extends StatelessWidget {
  const _SidebarDestinationButton({
    required this.index,
    required this.destination,
    required this.isSelected,
    required this.onDestinationSelected,
  });

  final int index;
  final ComponentNavigationDestination destination;
  final bool isSelected;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: _DestinationButton(
        index: index,
        destination: destination,
        isSelected: isSelected,
        iconSize: 22,
        onDestinationSelected: onDestinationSelected,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: isSelected ? context.chipColor : Colors.transparent,
            shape: const RoundedSuperellipseBorder(
              borderRadius: AppDecoration.borderRadiusLg,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              spacing: 12,
              children: [
                _DestinationIcon(
                  destination: destination,
                  isSelected: isSelected,
                  size: 22,
                ),
                Expanded(
                  child: Text(
                    destination.label,
                    style: (isSelected ? context.bodyHeavy : context.bodyMedium).copyWith(
                      color: isSelected ? context.primary : context.hintIntense,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DestinationButton extends StatelessWidget {
  const _DestinationButton({
    required this.index,
    required this.destination,
    required this.isSelected,
    required this.iconSize,
    required this.onDestinationSelected,
    this.child,
  });

  final int index;
  final ComponentNavigationDestination destination;
  final bool isSelected;
  final double iconSize;
  final ValueChanged<int> onDestinationSelected;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ComponentGestureClick(
      key: ValueKey<String>('nav-dest-$index'),
      semanticsLabel: destination.label,
      onTap: () => onDestinationSelected(index),
      child: ExcludeSemantics(
        child:
            child ??
            _DestinationIcon(
              destination: destination,
              isSelected: isSelected,
              size: iconSize,
            ),
      ),
    );
  }
}

class _DestinationIcon extends StatelessWidget {
  const _DestinationIcon({
    required this.destination,
    required this.isSelected,
    required this.size,
  });

  final ComponentNavigationDestination destination;
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
