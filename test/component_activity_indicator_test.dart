import 'package:flutter_components/component_activity_indicator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('ComponentActivityIndicator builds without error', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: const ComponentActivityIndicator(
        key: ValueKey<String>('activity-indicator'),
      ),
    );

    expect(find.byKey(const ValueKey<String>('activity-indicator')), findsOneWidget);
    expect(find.byType(ComponentActivityIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 16));
  });

  testWidgets('ComponentActivityIndicator accepts size and color', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: const ComponentActivityIndicator(
        size: 44,
        strokeWidth: 3.6,
        color: Color(0xFF2F80ED),
      ),
    );

    expect(find.byType(ComponentActivityIndicator), findsOneWidget);
    expect(tester.getSize(find.byType(ComponentActivityIndicator)), const Size(44, 44));
  });
}
