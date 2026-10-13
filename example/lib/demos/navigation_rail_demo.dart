import 'package:example/demos/navigation_rail_chrome.dart';
import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

enum _RailPreview { automatic, compact, extended }

class NavigationRailDemoPage extends StatefulWidget {
  const NavigationRailDemoPage({super.key});

  @override
  State<NavigationRailDemoPage> createState() => _NavigationRailDemoPageState();
}

class _NavigationRailDemoPageState extends State<NavigationRailDemoPage> {
  static const List<ComponentNavigationRailDestination> _destinations = [
    ComponentNavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    ComponentNavigationRailDestination(
      icon: Icon(Icons.search_rounded),
      label: 'Search',
    ),
    ComponentNavigationRailDestination(
      icon: Icon(Icons.inbox_outlined),
      selectedIcon: Icon(Icons.inbox_rounded),
      label: 'Inbox',
    ),
    ComponentNavigationRailDestination(
      icon: Icon(Icons.bookmark_outline_rounded),
      selectedIcon: Icon(Icons.bookmark_rounded),
      label: 'Saved',
    ),
    ComponentNavigationRailDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings_rounded),
      label: 'Settings',
    ),
  ];

  int _selectedIndex = 0;
  _RailPreview _preview = _RailPreview.automatic;

  ComponentNavigationRailMode? get _mode {
    return switch (_preview) {
      _RailPreview.automatic => null,
      _RailPreview.compact => ComponentNavigationRailMode.compact,
      _RailPreview.extended => ComponentNavigationRailMode.extended,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ComponentNavigationRailDestination destination = _destinations[_selectedIndex];

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ComponentNavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() => _selectedIndex = index);
            },
            destinations: _destinations,
            header: const NavigationRailDemoHeader(),
            footer: const NavigationRailDemoFooter(),
            mode: _mode,
          ),
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(ContextExtension.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (Navigator.of(context).canPop())
                          ComponentCloseButton.blurred(
                            onTap: () => Navigator.of(context).maybePop(),
                          ),
                        const Spacer(),
                        const ThemeToggleButton(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(destination.label, style: context.displayHeavy),
                    const SizedBox(height: 8),
                    Text(
                      'Header and footer stay pinned while destinations scroll.',
                      style: context.bodyMedium.copyWith(
                        color: context.hintIntense,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ComponentSegmentedControl<_RailPreview>(
                      value: _preview,
                      onChanged: (_RailPreview value) {
                        setState(() => _preview = value);
                      },
                      segments: const [
                        ComponentSegment(
                          value: _RailPreview.automatic,
                          label: 'Auto',
                        ),
                        ComponentSegment(
                          value: _RailPreview.compact,
                          label: 'Compact',
                        ),
                        ComponentSegment(
                          value: _RailPreview.extended,
                          label: 'Extended',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
