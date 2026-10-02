import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('shows capped count', (WidgetTester tester) async {
    await pumpComponentApp(tester, child: const ComponentBadge(count: 140));
    expect(find.text('99+'), findsOneWidget);
  });

  testWidgets('dot has no count label', (WidgetTester tester) async {
    await pumpComponentApp(tester, child: const ComponentBadge.dot(child: Icon(Icons.mail)));
    expect(find.textContaining('+'), findsNothing);
  });
}
