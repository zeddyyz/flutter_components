import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Wraps [child] in the package theme so widget tests match the gallery.
Future<void> pumpComponentApp(
  WidgetTester tester, {
  required Widget child,
  ThemeMode themeMode = ThemeMode.light,
  Size surfaceSize = const Size(400, 800),
}) async {
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
          darkTheme: AppThemeData.darkTheme(
            context: context,
            primaryColor: Colors.blue,
            secondaryColor: Colors.grey,
          ),
          themeMode: themeMode,
          home: Scaffold(body: child),
        );
      },
    ),
  );
}
