import 'package:flutter_components/component_search_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  const ValueKey<String> clearKey = ValueKey<String>('search-field-clear');
  const ValueKey<String> cancelKey = ValueKey<String>('search-field-cancel');

  testWidgets('entering text shows clear', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);

    await pumpComponentApp(
      tester,
      child: ComponentSearchField(controller: controller),
    );

    expect(find.byKey(clearKey), findsNothing);

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.pump();

    expect(find.byKey(clearKey), findsOneWidget);
  });

  testWidgets('clear empties controller', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);

    await pumpComponentApp(
      tester,
      child: ComponentSearchField(controller: controller),
    );

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.pump();
    expect(controller.text, 'hello');

    await tester.tap(find.byKey(clearKey));
    await tester.pump();

    expect(controller.text, isEmpty);
    expect(find.byKey(clearKey), findsNothing);
  });

  testWidgets('cancel visible when showCancelButton', (WidgetTester tester) async {
    final TextEditingController hiddenController = TextEditingController();
    final TextEditingController visibleController = TextEditingController();
    addTearDown(hiddenController.dispose);
    addTearDown(visibleController.dispose);

    await pumpComponentApp(
      tester,
      child: ComponentSearchField(controller: hiddenController),
    );
    expect(find.byKey(cancelKey), findsNothing);

    await pumpComponentApp(
      tester,
      child: ComponentSearchField(
        controller: visibleController,
        showCancelButton: true,
      ),
    );
    expect(find.byKey(cancelKey), findsOneWidget);
  });
}
