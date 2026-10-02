import 'package:flutter_components/component_skeleton.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  test('ComponentSkeleton named constructors exist', () {
    const ComponentSkeleton rect = ComponentSkeleton(width: 100, height: 40);
    const ComponentSkeleton circle = ComponentSkeleton.circle(diameter: 24);
    const ComponentSkeleton text = ComponentSkeleton.text(width: 80, height: 12);

    expect(rect, isA<ComponentSkeleton>());
    expect(circle, isA<ComponentSkeleton>());
    expect(text, isA<ComponentSkeleton>());
    expect(circle.width, 24);
    expect(circle.height, 24);
    expect(text.width, 80);
    expect(text.height, 12);
  });

  testWidgets('ComponentSkeleton builds without exceptions', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: const Column(
        children: [
          ComponentSkeleton(width: 120, height: 48),
          ComponentSkeleton.circle(diameter: 32),
          ComponentSkeleton.text(width: 96, height: 14),
        ],
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(ComponentSkeleton), findsNWidgets(3));

    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.takeException(), isNull);
  });

  testWidgets('ComponentSkeletonList builds without exceptions', (WidgetTester tester) async {
    await pumpComponentApp(
      tester,
      child: const ComponentSkeletonList(itemCount: 3),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(ComponentSkeletonList), findsOneWidget);
    expect(find.byType(ComponentSkeleton), findsNWidgets(9));

    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.takeException(), isNull);
  });
}
