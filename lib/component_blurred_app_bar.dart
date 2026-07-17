import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_components/shared/fade_mask_painter.dart';

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
    this.sigmaX = 12,
    this.sigmaY = 12,
    this.backgroundOpacity = 0.6,
    this.onBackButtonTap,
    this.bottom,
    this.titleSpacing,
    this.borderRadius,
    this.fadeSize = 8,
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

  /// Optional rounded clip for the blurred header. Provide a top-only radius
  /// when this app bar sits at the top of a modal sheet so the [BackdropFilter]
  /// is clipped to the sheet's rounded corners (a [BackdropFilter] ignores
  /// ancestor rounded clips). Defaults to a plain rectangular clip.
  final BorderRadius? borderRadius;

  /// The size of the fade mask
  final double fadeSize;

  @override
  Size get preferredSize => Size.fromHeight(
    (toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0),
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

    final resolvedBackgroundColor = backgroundColor ?? defaultBackgroundColor;

    final resolvedToolbarHeight =
        toolbarHeight ?? (borderRadius != null ? kToolbarHeight + 10 : kToolbarHeight);

    return _buildBlurAppBar(
      context,
      centerTitle: centerTitle ?? false,
      resolvedBackgroundColor: resolvedBackgroundColor,
      shouldShowLeading: shouldShowLeading,
      defaultForegroundColor: defaultForegroundColor,
      resolvedToolbarHeight: resolvedToolbarHeight,
      isLightTheme: isLightTheme,
    );
  }

  Widget _buildBlurAppBar(
    BuildContext context, {
    required bool centerTitle,
    required Color resolvedBackgroundColor,
    required bool shouldShowLeading,
    required Color defaultForegroundColor,
    required double resolvedToolbarHeight,
    required bool isLightTheme,
  }) {
    return ComponentClippedHeader(
      borderRadius: borderRadius,
      child: RepaintBoundary(
        child: Stack(
          children: [
            // Backdrop blur that fades out at the bottom edge so it ramps down
            // smoothly instead of ending in a hard line, mirroring the bottom
            // tab bar's faded blur. The status bar edge stays at full blur.
            Positioned.fill(
              child: RepaintBoundary(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
                  child: CustomPaint(
                    painter: FadeMaskPainter(fadeSize: fadeSize, isTopEdge: false),
                  ),
                ),
              ),
            ),
            // Background tint that fades from opaque at the top (status bar)
            // to transparent at the bottom edge.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      resolvedBackgroundColor,
                      resolvedBackgroundColor.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            AppBar(
              title: title,
              titleSpacing: titleSpacing,
              leadingWidth: leadingWidth ?? 54,
              titleTextStyle: context.textTheme.bodyMedium,
              leading: shouldShowLeading
                  ? (leading ?? ComponentBackButton(onTap: onBackButtonTap))
                  : null,
              actions: actions,
              actionsPadding: const EdgeInsets.only(right: 12),
              centerTitle: centerTitle,
              backgroundColor: Colors.transparent,
              foregroundColor: foregroundColor ?? defaultForegroundColor,
              elevation: elevation,
              scrolledUnderElevation: scrolledUnderElevation,
              automaticallyImplyLeading: false, // We handle this manually
              toolbarHeight: resolvedToolbarHeight,
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
          ],
        ),
      ),
    );
  }
}
