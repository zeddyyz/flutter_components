import 'package:flutter/material.dart';
import 'package:get/utils.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  // TextTheme get textTheme => theme.textTheme;
  // ColorScheme get colorScheme => theme.colorScheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool get isLightMode => theme.brightness == Brightness.light;

  double get viewWidth => MediaQuery.sizeOf(this).width;
  double get viewHeight => MediaQuery.sizeOf(this).height;

  bool get isPortraitView => MediaQuery.orientationOf(this) == Orientation.portrait;
  bool get isLandscapeView => MediaQuery.orientationOf(this) == Orientation.landscape;

  bool get isMobile => viewWidth <= 635;
  bool get isMediumScreen => viewWidth > 635 && viewWidth <= 920;
  bool get isLargeScreen => viewWidth > 920 && viewWidth <= 1200;
  bool get isXLargeScreen => viewWidth > 1200;

  Color get primary => isLightMode ? Colors.black : Colors.white;
  Color get primaryInverse => isLightMode ? Colors.white : Colors.black;

  Color get secondary => isLightMode ? Colors.grey : Colors.grey.shade700;

  Color get hint => isDarkMode ? Colors.grey.shade600 : Colors.grey;
  Color get hintIntense => isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600;

  Color get cardColor => isLightMode ? Colors.white : const Color.fromARGB(255, 18, 18, 18);
  Color get borderColor => isLightMode ? Colors.grey.shade200 : Colors.grey.shade900;
  Color get borderColorIntense => isLightMode
      ? Colors.grey.shade300.withValues(alpha: 0.75)
      : Colors.grey.shade800.withValues(alpha: 0.75);

  Color get chipColor => isLightMode ? Colors.grey.shade100 : Colors.grey.shade900;

  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  BottomSheetThemeData get bottomSheetTheme => Theme.of(this).bottomSheetTheme;

  Color get iconButtonBackgroundColor => isLightMode ? Colors.grey.shade200 : Colors.grey.shade900;

  Color get shimmerBaseColor =>
      isDarkMode ? const Color.fromARGB(255, 20, 20, 20) : const Color.fromARGB(255, 240, 240, 240);
  Color get shimmerHighlightColor =>
      isDarkMode ? const Color.fromARGB(255, 26, 26, 26) : const Color.fromARGB(255, 220, 220, 220);
  Color get shimmerBackgroundColor =>
      isDarkMode ? const Color.fromARGB(255, 25, 25, 25) : Colors.white;

  double get defaultPadding => isMobile
      ? 16.0
      : isMediumScreen
      ? 20.0
      : 24.0;

  double get defaultPaddingLargeScreen => isMobile
      ? 16.0
      : isMediumScreen
      ? 30.0
      : isLargeScreen
      ? 60.0
      : 120.0;

  double get cardPadding => isMobile
      ? 12.0
      : isMediumScreen
      ? 16.0
      : 20.0;

  double get defaultIconSize => isMobile
      ? 22.0
      : isMediumScreen
      ? 24.0
      : 26.0;

  double adaptiveSize(double value) => isMobile
      ? value
      : isMediumScreen
      ? value * 1.1
      : value * 1.2;

  int get gridViewCrossAxisCount => isMobile
      ? 1
      : isMediumScreen
      ? 2
      : isLargeScreen
      ? 3
      : 4;

  bool centerAppBarTitle(bool value) => isMobile
      ? true
      : value
      ? true
      : false;

  EdgeInsets get modernSliverPadding =>
      EdgeInsets.symmetric(
        vertical: adaptiveSize(16),
        horizontal: adaptiveSize(isPortraitView ? 16 : 24),
      ).copyWith(
        bottom: isMobile ? 110 : 20,
      );

  /// Padding for screens
  double topPadding(double value) => value + mediaQueryPadding.top + 20;
  double get bottomPadding => mediaQueryPadding.bottom + 80;
}
