import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class AdaptiveNavigationDemoPage extends StatefulWidget {
  const AdaptiveNavigationDemoPage({super.key});

  @override
  State<AdaptiveNavigationDemoPage> createState() => _AdaptiveNavigationDemoPageState();
}

class _AdaptiveNavigationDemoPageState extends State<AdaptiveNavigationDemoPage> {
  static const List<ComponentNavigationDestination> _destinations = [
    ComponentNavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    ComponentNavigationDestination(
      icon: Icon(Icons.search_rounded),
      label: 'Search',
    ),
    ComponentNavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings_rounded),
      label: 'Settings',
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ComponentAdaptiveNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() => _selectedIndex = index);
        },
        destinations: _destinations,
        leading: Text('Components', style: context.body2Bold),
        body: _DestinationBody(label: _destinations[_selectedIndex].label),
      ),
    );
  }
}

class _DestinationBody extends StatelessWidget {
  const _DestinationBody({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.defaultPadding),
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
            Text(label, style: context.displayHeavy),
            const SizedBox(height: 8),
            Text(
              'This is the $label destination.',
              style: context.bodyMedium.copyWith(color: context.hintIntense),
            ),
          ],
        ),
      ),
    );
  }
}
