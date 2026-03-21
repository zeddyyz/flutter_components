import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

class AppThemeData {
  static ThemeData lightTheme({
    required BuildContext context,
    required Color scaffoldBackgroundColor,
    required Color primaryColor,
    required Color secondaryColor,
    String? fontFamily,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      primaryColor: primaryColor,
      primaryColorLight: Colors.white,
      primaryColorDark: Colors.black,
      hintColor: secondaryColor,
      dividerTheme: DividerThemeData(
        color: primaryColor.withValues(alpha: 0.05),
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 21,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        actionsIconTheme: IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusLg,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 24 : 27,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
        displayMedium: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 24 : 27,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        displaySmall: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 24 : 27,
          fontWeight: FontWeight.normal,
          fontFamily: fontFamily,
        ),
        headlineLarge: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 20 : 23,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
        headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 20 : 23,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        headlineSmall: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 20 : 23,
          fontWeight: FontWeight.normal,
          fontFamily: fontFamily,
        ),
        titleLarge: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 17 : 20,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 17 : 20,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        titleSmall: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 17 : 20,
          fontWeight: FontWeight.normal,
          fontFamily: fontFamily,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 14 : 16,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 14 : 16,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        bodySmall: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 14 : 16,
          fontWeight: FontWeight.normal,
          fontFamily: fontFamily,
        ),
        labelLarge: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 12 : 14,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
        labelMedium: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 12 : 14,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        labelSmall: TextStyle(
          color: Colors.black,
          fontSize: context.isMobile ? 12 : 14,
          fontWeight: FontWeight.normal,
          fontFamily: fontFamily,
        ),
      ),
      iconTheme: IconThemeData(
        color: primaryColor,
        fill: 0,
        weight: 300,
        grade: 0,
        opticalSize: 48,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(primaryColor),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 50 : 54)),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: context.isMobile ? 16 : 19, fontWeight: FontWeight.w600),
          ),
          splashFactory: NoSplash.splashFactory,
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color.fromRGBO(12, 12, 12, 1.0)),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 50 : 54)),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: context.isMobile ? 16 : 19, fontWeight: FontWeight.w600),
          ),
          splashFactory: NoSplash.splashFactory,
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(scaffoldBackgroundColor),
          foregroundColor: WidgetStateProperty.all(primaryColor),
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 50 : 54)),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: context.isMobile ? 16 : 19, fontWeight: FontWeight.w600),
          ),
          splashFactory: NoSplash.splashFactory,
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(
              borderRadius: AppDecoration.borderRadiusStadium,
              side: BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
      ),
      splashColor: Colors.black12,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.grey.shade50,
        shape: RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusLg,
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: false,
        contentPadding: AppDecoration.spaceZero,
      ),
    );
  }

  static ThemeData darkTheme({
    required BuildContext context,
    required Color scaffoldBackgroundColor,
    required Color primaryColor,
    required Color secondaryColor,
    String? fontFamily,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      primaryColor: primaryColor,
      primaryColorLight: Color.fromARGB(255, 13, 13, 13),
      primaryColorDark: Colors.white,
      hintColor: secondaryColor,
      dividerTheme: DividerThemeData(
        color: primaryColor.withValues(alpha: 0.5),
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color.fromARGB(255, 20, 20, 20),
        elevation: 0,
        margin: AppDecoration.spaceZero,
        shape: RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusLg),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
        ),
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        titleSmall: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        bodySmall: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
        ),
        labelLarge: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
        ),
        labelMedium: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        labelSmall: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamily,
        ),
      ),
      iconTheme: IconThemeData(
        color: primaryColor,
        fill: 0,
        weight: 300,
        grade: 0,
        opticalSize: 48,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(primaryColor),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          iconColor: WidgetStateProperty.all(Colors.white),
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 50 : 54)),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: context.isMobile ? 16 : 19, fontWeight: FontWeight.w600),
          ),
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
          ),
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color.fromRGBO(245, 245, 245, 1.0)),
          foregroundColor: WidgetStateProperty.all(Colors.black),
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 50 : 54)),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: context.isMobile ? 16 : 19, fontWeight: FontWeight.w600),
          ),
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
          ),
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(scaffoldBackgroundColor),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 50 : 54)),
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: context.isMobile ? 16 : 19, fontWeight: FontWeight.w600),
          ),
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(
              borderRadius: AppDecoration.borderRadiusStadium,
              side: BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      splashColor: Colors.white10,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Color.fromARGB(255, 13, 13, 13),
        shape: RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusLg),
      ),
      listTileTheme: ListTileThemeData(
        dense: false,
        contentPadding: EdgeInsets.zero,
        shape: RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusLg),
      ),
    );
  }
}
