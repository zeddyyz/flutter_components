import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_components/component_back_button.dart';

// https://github.com/BlueBubblesApp/bluebubbles-app/blob/zach%2Ffeat%2Ftrue-foreground-service/lib%2Fapp%2Flayouts%2Fconversation_view%2Fwidgets%2Fheader%2Fcupertino_header.dart#L27-L52

class ComponentBlurredAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ComponentBlurredAppBar({
    super.key,
    required this.context,
    this.title,
    this.leading,
    this.leadingWidth,
    this.actions,
    this.centerTitle,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.scrolledUnderElevation = 0.0,
    this.automaticallyImplyLeading = true,
    this.toolbarHeight,
    this.systemOverlayStyle,
    this.sigmaX = 15,
    this.sigmaY = 15,
    this.backgroundOpacity = 0.6,
    this.onBackButtonTap,
    this.bottom,
    this.titleSpacing,
  });

  final BuildContext context;

  /// The title widget to display in the app bar
  final Widget? title;

  /// The leading widget, defaults to ModernBackButton if automaticallyImplyLeading is true
  final Widget? leading;

  /// The width of the leading widget. By default, the value is 56.0.
  final double? leadingWidth;

  /// List of action widgets to display at the end of the app bar
  final List<Widget>? actions;

  /// The bottom widget to display at the bottom of the app bar
  final PreferredSizeWidget? bottom;

  /// Whether to center the title
  final bool? centerTitle;

  /// The spacing between the title and the leading widget
  final double? titleSpacing;

  /// Background color of the app bar, defaults to scaffold background with blur
  final Color? backgroundColor;

  /// Foreground color for text and icons
  final Color? foregroundColor;

  /// Elevation of the app bar
  final double elevation;

  /// Elevation when content is scrolled under the app bar
  final double scrolledUnderElevation;

  /// Whether to automatically add a leading widget
  final bool automaticallyImplyLeading;

  /// Height of the toolbar
  final double? toolbarHeight;

  /// System overlay style for status bar
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Horizontal blur intensity
  final double sigmaX;

  /// Vertical blur intensity
  final double sigmaY;

  /// Opacity of the background color
  final double backgroundOpacity;

  /// Custom callback for back button tap
  final VoidCallback? onBackButtonTap;

  @override
  Size get preferredSize => Size.fromHeight(
    toolbarHeight ?? kToolbarHeight,
  );

  // simulate apple's saturatioon
  static const List<double> darkMatrix = <double>[
    1.385, -0.56, -0.112, 0.0, 0.3, //
    -0.315, 1.14, -0.112, 0.0, 0.3, //
    -0.315, -0.56, 1.588, 0.0, 0.3, //
    0.0, 0.0, 0.0, 1.0, 0.0,
  ];

  static const List<double> lightMatrix = <double>[
    1.74, -0.4, -0.17, 0.0, 0.0, //
    -0.26, 1.6, -0.17, 0.0, 0.0, //
    -0.26, -0.4, 1.83, 0.0, 0.0, //
    0.0, 0.0, 0.0, 1.0, 0.0,
  ];

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    final defaultBackgroundColor = scaffoldBackgroundColor.withValues(
      alpha: backgroundOpacity,
    );

    final defaultForegroundColor = isLightTheme ? Colors.black : Colors.white;

    final shouldShowLeading =
        automaticallyImplyLeading && (leading != null || ModalRoute.of(context)?.canPop == true);

    return ClipRect(
      child: RepaintBoundary(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          // filter: ImageFilter.compose(
          //   outer: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          //   inner: ColorFilter.matrix(
          //     context.isLightMode ? lightMatrix : darkMatrix,
          //   ),
          // ),
          child: AppBar(
            title: title,
            titleSpacing: titleSpacing,
            leadingWidth: leadingWidth,
            leading: shouldShowLeading
                ? (leading ?? ComponentBackButton(onTap: onBackButtonTap))
                : null,
            actions: actions,
            actionsPadding: const EdgeInsets.only(right: 6),
            centerTitle: centerTitle,
            backgroundColor: backgroundColor ?? defaultBackgroundColor,
            // backgroundColor: Colors.transparent,
            foregroundColor: foregroundColor ?? defaultForegroundColor,
            elevation: elevation,
            scrolledUnderElevation: scrolledUnderElevation,
            automaticallyImplyLeading: false,
            toolbarHeight: toolbarHeight ?? kToolbarHeight,
            systemOverlayStyle:
                systemOverlayStyle ??
                SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: isLightTheme ? Brightness.dark : Brightness.light,
                  statusBarBrightness: isLightTheme ? Brightness.light : Brightness.dark,
                  systemNavigationBarIconBrightness: isLightTheme
                      ? Brightness.dark
                      : Brightness.light,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarDividerColor: Colors.transparent,
                ),
            bottom: bottom,
          ),
        ),
      ),
    );
  }
}
