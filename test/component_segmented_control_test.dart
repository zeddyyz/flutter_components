import 'package:flutter_components/component_segmented_control.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('tapping a segment calls onChanged', (WidgetTester tester) async {
    final List<String> changed = <String>[];

    await pumpComponentApp(
      tester,
      child: ComponentSegmentedControl<String>(
        segments: const [
          ComponentSegment<String>(value: 'day', label: 'Day'),
          ComponentSegment<String>(value: 'week', label: 'Week'),
          ComponentSegment<String>(value: 'month', label: 'Month'),
        ],
        value: 'day',
        onChanged: changed.add,
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('segment-1')));
    await tester.pump();

    expect(changed, <String>['week']);
  });

  testWidgets('tapping a segment updates the selection', (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    String selected = 'list';

    await pumpComponentApp(
      tester,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ComponentSegmentedControl<String>(
            segments: const [
              ComponentSegment<String>(value: 'list', label: 'List'),
              ComponentSegment<String>(value: 'grid', label: 'Grid'),
            ],
            value: selected,
            onChanged: (String value) => setState(() => selected = value),
          );
        },
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('segment-1')));
    await tester.pumpAndSettle();

    expect(selected, 'grid');
    expect(
      tester.getSemantics(find.byKey(const ValueKey<String>('segment-0'))),
      isSemantics(isButton: true, isSelected: false, label: 'List'),
    );
    expect(
      tester.getSemantics(find.byKey(const ValueKey<String>('segment-1'))),
      isSemantics(isButton: true, isSelected: true, label: 'Grid'),
    );
    handle.dispose();
  });
}
