import 'package:example/example_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('gallery home loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();
    expect(find.text('Components'), findsWidgets);
    expect(find.text('Buttons'), findsOneWidget);
  });
}
