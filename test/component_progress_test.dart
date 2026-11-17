import 'dart:math' as math;

import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('progress widgets build', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: const Column(
        children: [
          ComponentProgressBar(value: 0.4),
          ComponentProgressRing(value: 0.4),
          ComponentPageIndicator(count: 3, index: 1),
        ],
      ),
    );
    expect(find.byType(ComponentProgressBar), findsOneWidget);
    expect(find.byType(ComponentPageIndicator), findsOneWidget);
  });

  testWidgets('progress bar starts at the given value', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: const SizedBox(
        width: 200,
        child: ComponentProgressBar(value: 0.4),
      ),
    );

    expect(_progressBarFillWidth(tester), closeTo(80, 0.5));
  });

  testWidgets('progress bar animates width when value changes', (WidgetTester tester) async {
    double value = 0.2;

    await pumpComponentApp(
      tester,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              SizedBox(
                width: 200,
                child: ComponentProgressBar(value: value),
              ),
              TextButton(
                onPressed: () => setState(() => value = 0.8),
                child: const Text('set'),
              ),
            ],
          );
        },
      ),
    );

    expect(_progressBarFillWidth(tester), closeTo(40, 0.5));

    await tester.tap(find.text('set'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 140));

    final double midWidth = _progressBarFillWidth(tester);
    expect(midWidth, greaterThan(40));
    expect(midWidth, lessThan(160));

    await tester.pumpAndSettle();
    expect(_progressBarFillWidth(tester), closeTo(160, 0.5));
  });

  testWidgets('progress ring starts at the given value', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: const ComponentProgressRing(value: 0.25),
    );

    expect(
      _progressRingPaint,
      paints
        ..arc(startAngle: 0, sweepAngle: math.pi * 2)
        ..arc(startAngle: -math.pi / 2, sweepAngle: math.pi * 2 * 0.25),
    );
  });

  testWidgets('progress ring animates sweep when value changes', (WidgetTester tester) async {
    double value = 0.25;

    await pumpComponentApp(
      tester,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              ComponentProgressRing(value: value),
              TextButton(
                onPressed: () => setState(() => value = 0.75),
                child: const Text('set'),
              ),
            ],
          );
        },
      ),
    );

    await tester.tap(find.text('set'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 140));

    final PaintPattern midPaint = paints
      ..arc(startAngle: 0, sweepAngle: math.pi * 2)
      ..something((Symbol method, List<dynamic> arguments) {
        if (method != #drawArc) {
          return false;
        }
        final double sweepAngle = arguments[2] as double;
        return sweepAngle > math.pi * 2 * 0.25 && sweepAngle < math.pi * 2 * 0.75;
      });
    expect(_progressRingPaint, midPaint);

    await tester.pumpAndSettle();
    expect(
      _progressRingPaint,
      paints
        ..arc(startAngle: 0, sweepAngle: math.pi * 2)
        ..arc(startAngle: -math.pi / 2, sweepAngle: math.pi * 2 * 0.75),
    );
  });
}

double _progressBarFillWidth(WidgetTester tester) {
  return tester
      .getSize(
        find.descendant(
          of: find.byType(AnimatedFractionallySizedBox),
          matching: find.byType(ColoredBox),
        ),
      )
      .width;
}

final Finder _progressRingPaint = find.descendant(
  of: find.byType(ComponentProgressRing),
  matching: find.byType(CustomPaint),
);
