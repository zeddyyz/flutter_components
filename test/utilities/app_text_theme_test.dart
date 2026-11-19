import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/pump_component_app.dart';

void main() {
  group('AppTextTheme.resolve', () {
    test('uses Apple body metrics on iOS', () {
      final theme = AppTextTheme.resolve(platform: TargetPlatform.iOS, color: Colors.black);

      expect(theme.body.fontSize, 17);
      expect(theme.body.height, 22 / 17);
      expect(theme.body.fontWeight, FontWeight.w400);
      expect(theme.headline.fontWeight, FontWeight.w600);
      expect(theme.callout.fontSize, 16);
      expect(theme.title3.fontSize, 20);
    });

    test('uses Material body metrics on Android', () {
      final theme = AppTextTheme.resolve(platform: TargetPlatform.android, color: Colors.black);

      expect(theme.body.fontSize, 16);
      expect(theme.body.height, 24 / 16);
      expect(theme.headline.fontWeight, FontWeight.w500);
      expect(theme.callout.fontSize, 16);
      expect(theme.title3.fontSize, 22);
    });

    test('weight modifiers override the default weight', () {
      final theme = AppTextTheme.resolve(platform: TargetPlatform.android, color: Colors.black);

      expect(theme.title.medium.fontWeight, FontWeight.w500);
      expect(theme.title.semibold.fontWeight, FontWeight.w600);
      expect(theme.title.bold.fontWeight, FontWeight.w700);
    });
  });

  testWidgets('context.textTheme is Material TextTheme from AppThemeData', (
    WidgetTester tester,
  ) async {
    late TextTheme material;
    await pumpComponentApp(
      tester,
      child: Builder(
        builder: (BuildContext context) {
          material = context.textTheme;
          return const SizedBox.shrink();
        },
      ),
    );

    expect(material.displayLarge?.fontSize, 28);
    expect(material.headlineLarge?.fontSize, 24);
    expect(material.titleLarge?.fontSize, 20);
    expect(material.bodyLarge?.fontSize, 16);
    expect(material.labelLarge?.fontSize, 11);
    expect(material.bodyMedium?.fontWeight, FontWeight.w500);
  });
}
