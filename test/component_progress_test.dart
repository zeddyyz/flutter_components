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
}
