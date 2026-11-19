import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('renders labels and the current step number', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: const ComponentStepper(
        labels: ['Cart', 'Ship', 'Pay'],
        currentStep: 1,
      ),
    );

    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Ship'), findsOneWidget);
    expect(find.text('Pay'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('connector starts filled for completed steps', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: const ComponentStepper(
        labels: ['Cart', 'Ship', 'Pay'],
        currentStep: 1,
      ),
    );

    expect(_connectorFillWidth(tester, 1), closeTo(_connectorWidth(tester, 1), 0.5));
    expect(_connectorFillWidth(tester, 2), closeTo(0, 0.5));
  });

  testWidgets('connector animates fill when the current step changes', (WidgetTester tester) async {
    int step = 0;

    await pumpComponentApp(
      tester,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              ComponentStepper(
                labels: const ['Cart', 'Ship', 'Pay'],
                currentStep: step,
              ),
              TextButton(
                onPressed: () => setState(() => step = 1),
                child: const Text('next'),
              ),
            ],
          );
        },
      ),
    );

    expect(_connectorFillWidth(tester, 1), closeTo(0, 0.5));

    await tester.tap(find.text('next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 140));

    final double midWidth = _connectorFillWidth(tester, 1);
    expect(midWidth, greaterThan(0));
    expect(midWidth, lessThan(_connectorWidth(tester, 1)));

    await tester.pumpAndSettle();
    expect(_connectorFillWidth(tester, 1), closeTo(_connectorWidth(tester, 1), 0.5));
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('connector animates unfill when stepping back', (WidgetTester tester) async {
    int step = 1;

    await pumpComponentApp(
      tester,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              ComponentStepper(
                labels: const ['Cart', 'Ship', 'Pay'],
                currentStep: step,
              ),
              TextButton(
                onPressed: () => setState(() => step = 0),
                child: const Text('back'),
              ),
            ],
          );
        },
      ),
    );

    final double filledWidth = _connectorWidth(tester, 1);
    expect(_connectorFillWidth(tester, 1), closeTo(filledWidth, 0.5));
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    await tester.tap(find.text('back'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 140));

    final double midWidth = _connectorFillWidth(tester, 1);
    expect(midWidth, greaterThan(0));
    expect(midWidth, lessThan(filledWidth));

    await tester.pumpAndSettle();
    expect(_connectorFillWidth(tester, 1), closeTo(0, 0.5));
    expect(find.byIcon(Icons.check_rounded), findsNothing);
  });
}

double _connectorWidth(WidgetTester tester, int index) {
  return tester.getSize(find.byKey(ValueKey<String>('stepper.connector.$index'))).width;
}

double _connectorFillWidth(WidgetTester tester, int index) {
  return tester
      .getSize(
        find.descendant(
          of: find.byKey(ValueKey<String>('stepper.connector.$index')),
          matching: find.descendant(
            of: find.byType(AnimatedFractionallySizedBox),
            matching: find.byType(ColoredBox),
          ),
        ),
      )
      .width;
}
