import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('chevron tile builds a trailing icon', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: ComponentListTile.chevron(
        title: const Text('Settings'),
        onTap: () {},
      ),
    );
    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
  });
}
