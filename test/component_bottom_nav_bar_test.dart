import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> pumpBottomNav(
    WidgetTester tester, {
    required List<Widget> childrenRightAligned,
  }) async {
    const Size surfaceSize = Size(400, 800);
    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            theme: AppThemeData.lightTheme(
              context: context,
              primaryColor: Colors.blue,
              secondaryColor: Colors.grey,
            ),
            home: Scaffold(
              extendBody: true,
              body: const SizedBox.expand(),
              bottomNavigationBar: ComponentBottomNavBar(
                isBackgroundFaded: true,
                childrenLeftAligned: const [
                  Icon(Icons.home_rounded, size: 32),
                  Icon(Icons.folder_rounded, size: 32),
                  Icon(Icons.settings_rounded, size: 32),
                ],
                childrenRightAligned: childrenRightAligned,
              ),
            ),
          );
        },
      ),
    );
  }

  testWidgets('single right child lays out as a circular pill', (WidgetTester tester) async {
    await pumpBottomNav(tester, childrenRightAligned: const [Icon(Icons.add_rounded, size: 32)]);
    expect(tester.takeException(), isNull);
    expect(find.byType(ComponentBottomNavBar), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
  });

  testWidgets('multiple right children shrink-wrap instead of using infinite width', (
    WidgetTester tester,
  ) async {
    await pumpBottomNav(
      tester,
      childrenRightAligned: const [
        Icon(Icons.add_rounded, size: 32),
        Icon(Icons.search_rounded, size: 32),
      ],
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(ComponentBottomNavBar), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
  });
}
