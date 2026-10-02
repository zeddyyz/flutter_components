import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('tapping toggles the value', (WidgetTester tester) async {
    bool value = false;
    await pumpComponentApp(
      tester,
      child: ComponentCheckbox(
        key: const ValueKey<String>('checkbox'),
        value: value,
        label: 'Accept',
        onChanged: (bool next) => value = next,
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('checkbox')));
    expect(value, isTrue);
  });
}
