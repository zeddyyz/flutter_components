import 'package:flutter_components/component_empty_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('finds title and message', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: const ComponentEmptyState(
        title: 'Inbox is empty',
        message: 'Messages you receive will show up here.',
      ),
    );

    expect(find.text('Inbox is empty'), findsOneWidget);
    expect(find.text('Messages you receive will show up here.'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('empty-state')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('empty-state-action')), findsNothing);
  });

  testWidgets('error variant builds', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: ComponentEmptyState.error(
        icon: const Icon(Icons.error_outline_rounded),
        title: 'Couldn’t load messages',
        message: 'Check your connection and try again.',
        action: TextButton(
          onPressed: () {},
          child: const Text('Retry'),
        ),
      ),
    );

    expect(find.text('Couldn’t load messages'), findsOneWidget);
    expect(find.text('Check your connection and try again.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('empty-state')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('empty-state-action')), findsOneWidget);
  });
}
