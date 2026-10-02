import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('ComponentListSection shows header, tiles, and footer', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: const ComponentListSection(
        header: 'General',
        footer: 'Manage how this device appears.',
        children: [
          ComponentListTile(
            title: Text('Wi-Fi'),
            backgroundColor: Colors.transparent,
          ),
          ComponentListTile(
            title: Text('Bluetooth'),
            backgroundColor: Colors.transparent,
          ),
          ComponentListTile(
            title: Text('Notifications'),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );

    expect(find.text('General'), findsOneWidget);
    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(find.text('Bluetooth'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.byType(ComponentListTile), findsNWidgets(3));
    expect(find.text('Manage how this device appears.'), findsOneWidget);
  });
}
