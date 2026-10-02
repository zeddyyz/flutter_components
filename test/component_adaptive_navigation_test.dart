import 'package:flutter_components/component_adaptive_navigation.dart';
import 'package:flutter_components/component_bottom_nav_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void _setViewSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  const Size mobileSize = Size(400, 800);
  const Size largeSize = Size(1200, 800);

  testWidgets('mobile shows bottom nav and tap changes index', (WidgetTester tester) async {
    _setViewSize(tester, mobileSize);
    await pumpComponentApp(
      tester,
      surfaceSize: mobileSize,
      child: const _NavHarness(leading: Text('Logo')),
    );

    expect(find.byType(ComponentBottomNavBar), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('adaptive-nav-sidebar')), findsNothing);
    expect(find.text('Logo'), findsNothing);
    expect(find.text('page-0'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('nav-dest-0')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('nav-dest-1')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('nav-dest-1')));
    await tester.pump();

    expect(find.text('page-1'), findsOneWidget);
    expect(find.text('page-0'), findsNothing);
  });

  testWidgets('large screen shows sidebar and tap changes index', (WidgetTester tester) async {
    _setViewSize(tester, largeSize);
    await pumpComponentApp(
      tester,
      surfaceSize: largeSize,
      child: const _NavHarness(leading: Text('Logo')),
    );

    expect(find.byType(ComponentBottomNavBar), findsNothing);
    expect(find.byKey(const ValueKey<String>('adaptive-nav-sidebar')), findsOneWidget);
    expect(find.text('Logo'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('page-0'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('nav-dest-2')));
    await tester.pump();

    expect(find.text('page-2'), findsOneWidget);
    expect(find.text('page-0'), findsNothing);
  });
}

class _NavHarness extends StatefulWidget {
  const _NavHarness({this.leading});

  final Widget? leading;

  @override
  State<_NavHarness> createState() => _NavHarnessState();
}

class _NavHarnessState extends State<_NavHarness> {
  int _selectedIndex = 0;

  static const List<ComponentNavigationDestination> _destinations = [
    ComponentNavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
    ComponentNavigationDestination(icon: Icon(Icons.search_rounded), label: 'Search'),
    ComponentNavigationDestination(icon: Icon(Icons.settings_rounded), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return ComponentAdaptiveNavigation(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
      destinations: _destinations,
      leading: widget.leading,
      body: Text('page-$_selectedIndex'),
    );
  }
}
