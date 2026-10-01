import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('ComponentThemeData is registered on AppThemeData', (WidgetTester tester) async {
    late ComponentThemeData theme;
    await pumpComponentApp(
      tester,
      child: Builder(
        builder: (BuildContext context) {
          theme = context.componentTheme;
          return const SizedBox.shrink();
        },
      ),
    );

    expect(theme.cardColor, Colors.white);
    expect(theme.dangerColor, Colors.red);
    expect(theme.cardBorderRadius, AppDecoration.borderRadiusCard);
  });
}
