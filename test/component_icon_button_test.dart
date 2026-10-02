import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('default constructor is icon-only until a label is passed', (
    WidgetTester tester,
  ) async {
    await pumpComponentApp(
      tester,
      child: ComponentIconButton(
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );

    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(TextButton), findsNothing);
    expect(find.text('Add'), findsNothing);
  });

  testWidgets('label switches any surface to icon + text', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: Column(
        children: [
          ComponentIconButton(
            icon: const Icon(Icons.add),
            label: const Text('Plain'),
            onPressed: () {},
          ),
          ComponentIconButton.filled(
            icon: const Icon(Icons.add),
            label: const Text('Filled'),
            onPressed: () {},
          ),
          ComponentIconButton.blurred(
            icon: const Icon(Icons.add),
            label: const Text('Blurred'),
            onPressed: () {},
          ),
        ],
      ),
    );

    expect(find.text('Plain'), findsOneWidget);
    expect(find.text('Filled'), findsOneWidget);
    expect(find.text('Blurred'), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(3));
  });

  testWidgets('loading replaces the icon and ignores presses', (WidgetTester tester) async {
    var pressed = false;

    await pumpComponentApp(
      tester,
      child: ComponentIconButton.filled(
        icon: const Icon(Icons.add),
        label: const Text('Save'),
        isLoading: true,
        onPressed: () => pressed = true,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(pressed, isFalse);
  });
}
