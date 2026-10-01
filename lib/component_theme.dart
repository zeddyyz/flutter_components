import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

/// Brandable tokens for flutter_components.
///
/// Registered by [AppThemeData]. New components should read from
/// [ComponentThemeData.of] instead of hard-coding light/dark colors.
class ComponentThemeData extends ThemeExtension<ComponentThemeData> {
  const ComponentThemeData({
    required this.cardColor,
    required this.sheetBackgroundColor,
    required this.sheetCardColor,
    required this.borderColor,
    required this.borderColorIntense,
    required this.chipColor,
    required this.iconButtonBackgroundColor,
    required this.hairlineColor,
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
    required this.shimmerBackgroundColor,
    required this.hintColor,
    required this.dangerColor,
    this.cardBorderRadius = AppDecoration.borderRadiusCard,
    this.stadiumBorderRadius = AppDecoration.borderRadiusStadium,
    this.modalBorderRadius = AppDecoration.iOSModalBorderRadius,
  });

  final Color cardColor;
  final Color sheetBackgroundColor;
  final Color sheetCardColor;
  final Color borderColor;
  final Color borderColorIntense;
  final Color chipColor;
  final Color iconButtonBackgroundColor;
  final Color hairlineColor;
  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;
  final Color shimmerBackgroundColor;
  final Color hintColor;
  final Color dangerColor;
  final BorderRadius cardBorderRadius;
  final BorderRadius stadiumBorderRadius;
  final BorderRadius modalBorderRadius;

  factory ComponentThemeData.light({
    Color? sheetBackgroundColor,
  }) {
    return ComponentThemeData(
      cardColor: Colors.white,
      sheetBackgroundColor: sheetBackgroundColor ?? const Color(0xfff2f2f7),
      sheetCardColor: const Color(0xffffffff),
      borderColor: Colors.grey.shade200,
      borderColorIntense: Colors.grey.shade300.withValues(alpha: 0.75),
      chipColor: Colors.grey.shade300.withValues(alpha: 0.75),
      iconButtonBackgroundColor: Colors.grey.shade300.withValues(alpha: 0.75),
      hairlineColor: Colors.black.withValues(alpha: 0.08),
      shimmerBaseColor: const Color.fromARGB(255, 240, 240, 240),
      shimmerHighlightColor: const Color.fromARGB(255, 220, 220, 220),
      shimmerBackgroundColor: Colors.white,
      hintColor: Colors.grey,
      dangerColor: Colors.red,
    );
  }

  factory ComponentThemeData.dark({
    Color? sheetBackgroundColor,
  }) {
    return ComponentThemeData(
      cardColor: const Color.fromARGB(255, 22, 22, 24),
      sheetBackgroundColor: sheetBackgroundColor ?? const Color(0xff1c1c1e),
      sheetCardColor: const Color(0xff2c2c2e),
      borderColor: Colors.grey.shade900,
      borderColorIntense: Colors.grey.shade800.withValues(alpha: 0.75),
      chipColor: Colors.grey.shade900,
      iconButtonBackgroundColor: Colors.grey.shade900,
      hairlineColor: Colors.white.withValues(alpha: 0.1),
      shimmerBaseColor: const Color.fromARGB(255, 20, 20, 20),
      shimmerHighlightColor: const Color.fromARGB(255, 26, 26, 26),
      shimmerBackgroundColor: const Color.fromARGB(255, 25, 25, 25),
      hintColor: Colors.grey.shade600,
      dangerColor: Colors.red,
    );
  }

  static ComponentThemeData of(BuildContext context) {
    return Theme.of(context).extension<ComponentThemeData>() ??
        (Theme.of(context).brightness == Brightness.dark
            ? ComponentThemeData.dark()
            : ComponentThemeData.light());
  }

  @override
  ComponentThemeData copyWith({
    Color? cardColor,
    Color? sheetBackgroundColor,
    Color? sheetCardColor,
    Color? borderColor,
    Color? borderColorIntense,
    Color? chipColor,
    Color? iconButtonBackgroundColor,
    Color? hairlineColor,
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
    Color? shimmerBackgroundColor,
    Color? hintColor,
    Color? dangerColor,
    BorderRadius? cardBorderRadius,
    BorderRadius? stadiumBorderRadius,
    BorderRadius? modalBorderRadius,
  }) {
    return ComponentThemeData(
      cardColor: cardColor ?? this.cardColor,
      sheetBackgroundColor: sheetBackgroundColor ?? this.sheetBackgroundColor,
      sheetCardColor: sheetCardColor ?? this.sheetCardColor,
      borderColor: borderColor ?? this.borderColor,
      borderColorIntense: borderColorIntense ?? this.borderColorIntense,
      chipColor: chipColor ?? this.chipColor,
      iconButtonBackgroundColor: iconButtonBackgroundColor ?? this.iconButtonBackgroundColor,
      hairlineColor: hairlineColor ?? this.hairlineColor,
      shimmerBaseColor: shimmerBaseColor ?? this.shimmerBaseColor,
      shimmerHighlightColor: shimmerHighlightColor ?? this.shimmerHighlightColor,
      shimmerBackgroundColor: shimmerBackgroundColor ?? this.shimmerBackgroundColor,
      hintColor: hintColor ?? this.hintColor,
      dangerColor: dangerColor ?? this.dangerColor,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      stadiumBorderRadius: stadiumBorderRadius ?? this.stadiumBorderRadius,
      modalBorderRadius: modalBorderRadius ?? this.modalBorderRadius,
    );
  }

  @override
  ComponentThemeData lerp(ThemeExtension<ComponentThemeData>? other, double t) {
    if (other is! ComponentThemeData) return this;
    return ComponentThemeData(
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      sheetBackgroundColor: Color.lerp(sheetBackgroundColor, other.sheetBackgroundColor, t)!,
      sheetCardColor: Color.lerp(sheetCardColor, other.sheetCardColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      borderColorIntense: Color.lerp(borderColorIntense, other.borderColorIntense, t)!,
      chipColor: Color.lerp(chipColor, other.chipColor, t)!,
      iconButtonBackgroundColor: Color.lerp(
        iconButtonBackgroundColor,
        other.iconButtonBackgroundColor,
        t,
      )!,
      hairlineColor: Color.lerp(hairlineColor, other.hairlineColor, t)!,
      shimmerBaseColor: Color.lerp(shimmerBaseColor, other.shimmerBaseColor, t)!,
      shimmerHighlightColor: Color.lerp(shimmerHighlightColor, other.shimmerHighlightColor, t)!,
      shimmerBackgroundColor: Color.lerp(shimmerBackgroundColor, other.shimmerBackgroundColor, t)!,
      hintColor: Color.lerp(hintColor, other.hintColor, t)!,
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t)!,
      cardBorderRadius: BorderRadius.lerp(cardBorderRadius, other.cardBorderRadius, t)!,
      stadiumBorderRadius: BorderRadius.lerp(stadiumBorderRadius, other.stadiumBorderRadius, t)!,
      modalBorderRadius: BorderRadius.lerp(modalBorderRadius, other.modalBorderRadius, t)!,
    );
  }
}
