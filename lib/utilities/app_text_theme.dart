import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';

/// Semantic type styles for flutter_components.
///
/// Apple uses the iOS "Large (Default)" Dynamic Type metrics; every other
/// platform, including web, uses the Material 3 type scale. The OS text-size
/// setting is applied by [TextScaler].
///
/// Use from a [BuildContext] as `context.textTheme.title` and change weight
/// with `.medium`, `.semibold`, or `.bold`.
class AppTextTheme extends ThemeExtension<AppTextTheme> {
  const AppTextTheme({
    required this.screenTitle,
    required this.largeTitle,
    required this.title,
    required this.title3,
    required this.headline,
    required this.body,
    required this.callout,
    required this.subheadline,
    required this.footnote,
    required this.caption1,
    required this.caption2,
  });

  /// Large collapsing screen titles (use `.bold`).
  final TextStyle screenTitle;

  /// Hero numbers, prices, stats, onboarding titles (use `.bold`).
  final TextStyle largeTitle;

  /// Larger headings on roomy screens.
  final TextStyle title;

  /// Section headings, sheet headers, empty state titles (use `.semibold`).
  final TextStyle title3;

  /// Card titles, dialog titles, emphasised list rows.
  final TextStyle headline;

  /// List row titles, paragraphs, text field input, trailing values.
  final TextStyle body;

  /// Quotes, notes, callout boxes, inline text buttons (use `.semibold`).
  final TextStyle callout;

  /// List subtitles, card descriptions, dialog messages, snackbars, field labels.
  final TextStyle subheadline;

  /// Timestamps, metadata, helper/error text, section headers, tooltips, chips.
  final TextStyle footnote;

  /// Character counters, legal and fine print.
  final TextStyle caption1;

  /// Tab bar and bottom nav labels, badge counts.
  final TextStyle caption2;

  factory AppTextTheme.resolve({
    TargetPlatform? platform,
    required Color color,
    String? fontFamily,
  }) {
    TextStyle styleFor(AppTextRole role) => role.style(
      platform: platform ?? defaultTargetPlatform,
      color: color,
      fontFamily: fontFamily,
    );
    return AppTextTheme(
      screenTitle: styleFor(AppTextRole.largeTitle),
      largeTitle: styleFor(AppTextRole.title1),
      title: styleFor(AppTextRole.title2),
      title3: styleFor(AppTextRole.title3),
      headline: styleFor(AppTextRole.headline),
      body: styleFor(AppTextRole.body),
      callout: styleFor(AppTextRole.callout),
      subheadline: styleFor(AppTextRole.subheadline),
      footnote: styleFor(AppTextRole.footnote),
      caption1: styleFor(AppTextRole.caption1),
      caption2: styleFor(AppTextRole.caption2),
    );
  }

  static AppTextTheme of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<AppTextTheme>() ??
        AppTextTheme.resolve(
          platform: theme.platform,
          color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
          fontFamily: theme.textTheme.bodyLarge?.fontFamily,
        );
  }

  /// Material [TextTheme] slots so built-in widgets pick up the same sizes.
  TextTheme toMaterialTextTheme() {
    return TextTheme(
      displayLarge: screenTitle,
      displayMedium: largeTitle,
      displaySmall: title,
      headlineLarge: screenTitle,
      headlineMedium: largeTitle,
      headlineSmall: title,
      titleLarge: title3,
      titleMedium: headline,
      titleSmall: subheadline.medium,
      bodyLarge: body,
      bodyMedium: subheadline,
      bodySmall: footnote,
      labelLarge: subheadline.medium,
      labelMedium: caption1.medium,
      labelSmall: caption2.medium,
    );
  }

  @override
  AppTextTheme copyWith({
    TextStyle? screenTitle,
    TextStyle? largeTitle,
    TextStyle? title,
    TextStyle? title3,
    TextStyle? headline,
    TextStyle? body,
    TextStyle? callout,
    TextStyle? subheadline,
    TextStyle? footnote,
    TextStyle? caption1,
    TextStyle? caption2,
  }) {
    return AppTextTheme(
      screenTitle: screenTitle ?? this.screenTitle,
      largeTitle: largeTitle ?? this.largeTitle,
      title: title ?? this.title,
      title3: title3 ?? this.title3,
      headline: headline ?? this.headline,
      body: body ?? this.body,
      callout: callout ?? this.callout,
      subheadline: subheadline ?? this.subheadline,
      footnote: footnote ?? this.footnote,
      caption1: caption1 ?? this.caption1,
      caption2: caption2 ?? this.caption2,
    );
  }

  @override
  AppTextTheme lerp(ThemeExtension<AppTextTheme>? other, double t) {
    if (other is! AppTextTheme) return this;
    return AppTextTheme(
      screenTitle: TextStyle.lerp(screenTitle, other.screenTitle, t)!,
      largeTitle: TextStyle.lerp(largeTitle, other.largeTitle, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      title3: TextStyle.lerp(title3, other.title3, t)!,
      headline: TextStyle.lerp(headline, other.headline, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      callout: TextStyle.lerp(callout, other.callout, t)!,
      subheadline: TextStyle.lerp(subheadline, other.subheadline, t)!,
      footnote: TextStyle.lerp(footnote, other.footnote, t)!,
      caption1: TextStyle.lerp(caption1, other.caption1, t)!,
      caption2: TextStyle.lerp(caption2, other.caption2, t)!,
    );
  }
}

/// Size, leading, and default weight for each [AppTextTheme] role.
enum AppTextRole {
  largeTitle(appleSize: 34, appleLeading: 41, materialSize: 32, materialLeading: 40),
  title1(appleSize: 28, appleLeading: 34, materialSize: 28, materialLeading: 36),
  title2(appleSize: 22, appleLeading: 28, materialSize: 24, materialLeading: 32),
  title3(appleSize: 20, appleLeading: 25, materialSize: 22, materialLeading: 28),
  headline(
    appleSize: 17,
    appleLeading: 22,
    materialSize: 16,
    materialLeading: 24,
    appleWeight: FontWeight.w600,
    materialWeight: FontWeight.w500,
  ),
  body(appleSize: 17, appleLeading: 22, materialSize: 16, materialLeading: 24),
  callout(appleSize: 16, appleLeading: 21, materialSize: 16, materialLeading: 24),
  subheadline(appleSize: 15, appleLeading: 20, materialSize: 14, materialLeading: 20),
  footnote(appleSize: 13, appleLeading: 18, materialSize: 12, materialLeading: 16),
  caption1(appleSize: 12, appleLeading: 16, materialSize: 12, materialLeading: 16),
  caption2(appleSize: 11, appleLeading: 13, materialSize: 11, materialLeading: 16);

  const AppTextRole({
    required this.appleSize,
    required this.appleLeading,
    required this.materialSize,
    required this.materialLeading,
    this.appleWeight = FontWeight.w400,
    this.materialWeight = FontWeight.w400,
  });

  final double appleSize;
  final double appleLeading;
  final double materialSize;
  final double materialLeading;
  final FontWeight appleWeight;
  final FontWeight materialWeight;

  static bool usesAppleMetrics(TargetPlatform platform) =>
      !kIsWeb && (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS);

  TextStyle style({required TargetPlatform platform, Color? color, String? fontFamily}) {
    final isApple = usesAppleMetrics(platform);
    final fontSize = isApple ? appleSize : materialSize;
    final leading = isApple ? appleLeading : materialLeading;
    return TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: leading / fontSize,
      leadingDistribution: TextLeadingDistribution.even,
      fontWeight: isApple ? appleWeight : materialWeight,
    );
  }
}

extension TextStyleWeightX on TextStyle {
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semibold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
}
