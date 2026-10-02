import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('renders two-letter initials', (WidgetTester tester) async {
    await pumpComponentApp(tester, child: const ComponentAvatar(initials: 'Ada Lovelace'));
    expect(find.text('AL'), findsOneWidget);
  });
}
