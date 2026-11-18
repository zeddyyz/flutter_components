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

    test('maps semantic styles onto Material TextTheme slots', () {
      final theme = AppTextTheme.resolve(platform: TargetPlatform.android, color: Colors.black);
      final material = theme.toMaterialTextTheme();

      expect(material.displayLarge, theme.screenTitle);
      expect(material.titleLarge, theme.title3);
      expect(material.titleMedium, theme.headline);
      expect(material.bodyLarge, theme.body);
      expect(material.bodyMedium, theme.subheadline);
      expect(material.bodySmall, theme.footnote);
      expect(material.labelSmall, theme.caption2.medium);
    });
  });

  testWidgets('context.textTheme is the AppTextTheme registered on AppThemeData', (
    WidgetTester tester,
  ) async {
    late AppTextTheme fromContext;
    late TextTheme material;
    await pumpComponentApp(
      tester,
      child: Builder(
        builder: (BuildContext context) {
          fromContext = context.textTheme;
          material = Theme.of(context).textTheme;
          return const SizedBox.shrink();
        },
      ),
    );

    expect(fromContext, isA<AppTextTheme>());
    expect(material.titleMedium?.fontSize, fromContext.headline.fontSize);
    expect(material.titleMedium?.fontWeight, fromContext.headline.fontWeight);
    expect(material.bodyLarge?.fontSize, fromContext.body.fontSize);
  });
}
