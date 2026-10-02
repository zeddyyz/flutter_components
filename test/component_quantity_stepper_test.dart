import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('increment and decrement change the value', (WidgetTester tester) async {
    int value = 2;
    await pumpComponentApp(
      tester,
      child: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return ComponentQuantityStepper(
            value: value,
            onChanged: (int next) => setState(() => value = next),
          );
        },
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('quantity-increment')));
    await tester.pump();
    expect(value, 3);
    await tester.tap(find.byKey(const ValueKey<String>('quantity-decrement')));
    await tester.pump();
    expect(value, 2);
  });
}
