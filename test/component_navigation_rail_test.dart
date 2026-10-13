import 'package:flutter_components/component_navigation_rail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void _setViewSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  const Size mediumSize = Size(720, 900);
  const Size largeSize = Size(1200, 800);

  testWidgets(
    'automatic mode is compact on a tablet and extended on a desktop',
    (WidgetTester tester) async {
      _setViewSize(tester, mediumSize);
      await pumpComponentApp(
        tester,
        surfaceSize: mediumSize,
        child: const _RailHarness(),
      );

      expect(find.text('mode-compact'), findsNWidgets(2));
      expect(find.text('Home'), findsNothing);
      expect(
        tester.getSize(find.byKey(const ValueKey<String>('navigation-rail'))).width,
        80,
      );

      _setViewSize(tester, largeSize);
      await pumpComponentApp(
        tester,
        surfaceSize: largeSize,
        child: const _RailHarness(),
      );

      expect(find.text('mode-extended'), findsNWidgets(2));
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(
        tester.getSize(find.byKey(const ValueKey<String>('navigation-rail'))).width,
        240,
      );
    },
  );

  testWidgets('selecting a destination updates the body', (
    WidgetTester tester,
  ) async {
    _setViewSize(tester, largeSize);
    await pumpComponentApp(
      tester,
      surfaceSize: largeSize,
      child: const _RailHarness(),
    );

    await tester.tap(find.byKey(const ValueKey<String>('nav-dest-2')));
    await tester.pump();

    expect(find.text('page-2'), findsOneWidget);
    expect(find.text('page-0'), findsNothing);
  });

  testWidgets('forced modes ignore the screen size', (
    WidgetTester tester,
  ) async {
    _setViewSize(tester, largeSize);
    await pumpComponentApp(
      tester,
      surfaceSize: largeSize,
      child: const _RailHarness(mode: ComponentNavigationRailMode.compact),
    );

    expect(find.text('mode-compact'), findsNWidgets(2));
    expect(find.text('Home'), findsNothing);
    expect(
      tester.getSize(find.byKey(const ValueKey<String>('navigation-rail'))).width,
      80,
    );

    _setViewSize(tester, mediumSize);
    await pumpComponentApp(
      tester,
      surfaceSize: mediumSize,
      child: const _RailHarness(mode: ComponentNavigationRailMode.extended),
    );

    expect(find.text('mode-extended'), findsNWidgets(2));
    expect(find.text('Settings'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey<String>('navigation-rail'))).width,
      220,
    );
  });
}

class _RailHarness extends StatefulWidget {
  const _RailHarness({this.mode});

  final ComponentNavigationRailMode? mode;

  @override
  State<_RailHarness> createState() => _RailHarnessState();
}

class _RailHarnessState extends State<_RailHarness> {
  int _selectedIndex = 0;

  static const List<ComponentNavigationRailDestination> _destinations = [
    ComponentNavigationRailDestination(
      icon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    ComponentNavigationRailDestination(
      icon: Icon(Icons.search_rounded),
      label: 'Search',
    ),
    ComponentNavigationRailDestination(
      icon: Icon(Icons.settings_rounded),
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ComponentNavigationRail(
          key: const ValueKey<String>('navigation-rail'),
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
          destinations: _destinations,
          header: const _ScopeLabel(),
          footer: const _ScopeLabel(),
          mode: widget.mode,
        ),
        Expanded(child: Text('page-$_selectedIndex')),
      ],
    );
  }
}

class _ScopeLabel extends StatelessWidget {
  const _ScopeLabel();

  @override
  Widget build(BuildContext context) {
    final bool isExtended = ComponentNavigationRailScope.isExtendedOf(context);
    return Text(isExtended ? 'mode-extended' : 'mode-compact');
  }
}
