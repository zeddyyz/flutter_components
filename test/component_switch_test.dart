import 'package:flutter_components/component_switch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('tap toggles value', (WidgetTester tester) async {
    bool value = false;

    await pumpComponentApp(
      tester,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ComponentSwitch(
            value: value,
            onChanged: (bool next) => setState(() => value = next),
          );
        },
      ),
    );

    expect(value, isFalse);

    await tester.tap(find.byType(ComponentSwitch));
    await tester.pumpAndSettle();
    expect(value, isTrue);

    await tester.tap(find.byType(ComponentSwitch));
    await tester.pumpAndSettle();
    expect(value, isFalse);
  });

  testWidgets('disabled does not toggle', (WidgetTester tester) async {
    const bool value = true;

    await pumpComponentApp(
      tester,
      child: const ComponentSwitch(
        value: value,
        onChanged: null,
      ),
    );

    await tester.tap(find.byType(ComponentSwitch));
    await tester.pumpAndSettle();

    final ComponentSwitch switchWidget = tester.widget<ComponentSwitch>(
      find.byType(ComponentSwitch),
    );
    expect(switchWidget.value, isTrue);
    expect(switchWidget.onChanged, isNull);
  });
}
