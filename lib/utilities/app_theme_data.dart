import 'package:flutter/services.dart';
import 'package:flutter_components/component_theme.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class AppThemeData {
  static AppTextTheme _appTextTheme({required Color color, String? fontFamily}) =>
      AppTextTheme.resolve(color: color, fontFamily: fontFamily);

  static ThemeData lightTheme({
    required BuildContext context,
    Color? scaffoldBackgroundColor,
    required Color primaryColor,
    required Color secondaryColor,
    String? fontFamily,
    ColorScheme? colorScheme,
    Color? bottomSheetBackgroundColor,
  }) {
    final fallbackScaffoldBackgroundColor = const Color.fromARGB(255, 246, 246, 246);
    final appTextTheme = _appTextTheme(color: Colors.black, fontFamily: fontFamily);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      // scaffoldBackgroundColor: scaffoldBackgroundColor ?? Color(0xfff2f2f7),
      scaffoldBackgroundColor: scaffoldBackgroundColor ?? fallbackScaffoldBackgroundColor,
      primaryColor: primaryColor,
      primaryColorLight: Colors.white,
      primaryColorDark: Colors.black,
      hintColor: secondaryColor,
      dividerTheme: DividerThemeData(
        color: primaryColor.withValues(alpha: 0.05),
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor ?? fallbackScaffoldBackgroundColor,
        titleTextStyle: appTextTheme.title3.semibold,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        actionsIconTheme: IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
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
      fontFamily: fontFamily,
      textTheme: appTextTheme.toMaterialTextTheme(),
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
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 52 : 54)),
          textStyle: WidgetStatePropertyAll(appTextTheme.headline.semibold),
          splashFactory: NoSplash.splashFactory,
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
          ),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color.fromRGBO(12, 12, 12, 1.0)),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 52 : 54)),
          textStyle: WidgetStatePropertyAll(appTextTheme.headline.semibold),
          splashFactory: NoSplash.splashFactory,
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
          ),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(scaffoldBackgroundColor),
          foregroundColor: WidgetStateProperty.all(primaryColor),
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 52 : 54)),
          textStyle: WidgetStatePropertyAll(appTextTheme.headline.semibold),
          splashFactory: NoSplash.splashFactory,
          elevation: WidgetStateProperty.all(0),
          side: WidgetStateProperty.all(
            BorderSide(
              color: context.borderColorIntense,
              width: 1.5,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(
              borderRadius: AppDecoration.borderRadiusStadium,
            ),
          ),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(primaryColor),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          textStyle: WidgetStatePropertyAll(appTextTheme.headline.semibold),
          splashFactory: NoSplash.splashFactory,
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
          ),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      splashColor: Colors.black12,
      bottomSheetTheme: BottomSheetThemeData(
        // backgroundColor: bottomSheetBackgroundColor ?? Color(0xfff2f2f7),
        backgroundColor: bottomSheetBackgroundColor ?? Color(0xfff2f2f7),
        shadowColor: Colors.black45,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.only(
            topLeft: AppDecoration.iOSModalRadius,
            topRight: AppDecoration.iOSModalRadius,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: false,
        contentPadding: AppDecoration.spaceZero,
        shape: RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusCard),
      ),
      extensions: <ThemeExtension<dynamic>>[
        appTextTheme,
        ComponentThemeData.light(
          sheetBackgroundColor: bottomSheetBackgroundColor ?? Color(0xfff2f2f7),
        ),
      ],
    );
  }

  static ThemeData darkTheme({
    required BuildContext context,
    Color? scaffoldBackgroundColor,
    required Color primaryColor,
    required Color secondaryColor,
    String? fontFamily,
    ColorScheme? colorScheme,
    Color? bottomSheetBackgroundColor,
  }) {
    final appTextTheme = _appTextTheme(color: Colors.white, fontFamily: fontFamily);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor ?? Color(0xff000000),
      primaryColor: primaryColor,
      primaryColorLight: Color.fromARGB(255, 13, 13, 13),
      primaryColorDark: Colors.white,
      hintColor: secondaryColor,
      dividerTheme: DividerThemeData(
        color: primaryColor.withValues(alpha: 0.5),
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor ?? Color(0xff000000),
        titleTextStyle: appTextTheme.title3.semibold,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        actionsIconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
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
      fontFamily: fontFamily,
      textTheme: appTextTheme.toMaterialTextTheme(),
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
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 52 : 54)),
          textStyle: WidgetStatePropertyAll(appTextTheme.headline.semibold),
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
          ),
          splashFactory: NoSplash.splashFactory,
          elevation: WidgetStateProperty.all(0),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color.fromRGBO(245, 245, 245, 1.0)),
          foregroundColor: WidgetStateProperty.all(Colors.black),
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 52 : 54)),
          textStyle: WidgetStatePropertyAll(appTextTheme.headline.semibold),
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
          ),
          splashFactory: NoSplash.splashFactory,
          elevation: WidgetStateProperty.all(0),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(scaffoldBackgroundColor),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 52 : 54)),
          textStyle: WidgetStatePropertyAll(appTextTheme.headline.semibold),
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(
              borderRadius: AppDecoration.borderRadiusStadium,
            ),
          ),
          splashFactory: NoSplash.splashFactory,
          elevation: WidgetStateProperty.all(0),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(primaryColor),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          textStyle: WidgetStatePropertyAll(appTextTheme.headline.semibold),
          splashFactory: NoSplash.splashFactory,
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
          ),
          mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
      splashColor: Colors.white10,
      bottomSheetTheme: BottomSheetThemeData(
        // backgroundColor: bottomSheetBackgroundColor ?? Color(0xff1c1b1d),
        backgroundColor: bottomSheetBackgroundColor ?? Color(0xff1c1c1e),
        shadowColor: Colors.black54,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.only(
            topLeft: AppDecoration.iOSModalRadius,
            topRight: AppDecoration.iOSModalRadius,
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: false,
        contentPadding: EdgeInsets.zero,
        shape: RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusCard),
      ),
      extensions: <ThemeExtension<dynamic>>[
        appTextTheme,
        ComponentThemeData.dark(
          sheetBackgroundColor: bottomSheetBackgroundColor ?? Color(0xff1c1c1e),
        ),
      ],
    );
  }
}
