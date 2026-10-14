import 'package:flutter_components/utilities/alert_snackbar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump_component_app.dart';

void main() {
  tearDown(AlertSnackbar.debugReset);

  testWidgets('show without init renders a toast and does not throw', (
    WidgetTester tester,
  ) async {
    await pumpComponentApp(tester, child: const SizedBox.shrink());
    AlertSnackbar.show(message: 'Login failed', isError: true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.takeException(), isNull);
    expect(find.text('Login failed'), findsOneWidget);
    AlertSnackbar.debugReset();
  });

  testWidgets('show with no reachable overlay is a silent no-op', (
    WidgetTester tester,
  ) async {
    AlertSnackbar.show(message: 'Should not appear');
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Should not appear'), findsNothing);
  });

  testWidgets('show after init still renders a toast', (WidgetTester tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                AlertSnackbar.init(context);
                return const Scaffold(body: SizedBox.shrink());
              },
            ),
          );
        },
      ),
    );
    AlertSnackbar.show(message: 'Saved');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.takeException(), isNull);
    expect(find.text('Saved'), findsOneWidget);
    AlertSnackbar.debugReset();
  });
}
