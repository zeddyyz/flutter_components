import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_components/component_back_button.dart';

class ComponentSliverBlurredAppBar extends StatelessWidget {
  const ComponentSliverBlurredAppBar({
    super.key,
    required this.context,
    this.title,
    this.leading,
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
    this.expandedHeight,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.stretch = false,
    this.stretchTriggerOffset = 100.0,
    this.onStretchTrigger,
    this.forceElevated = false,
    this.clipBehavior,
  });

  final BuildContext context;

  /// The title widget to display in the app bar
  final Widget? title;

  /// The leading widget, defaults to ModernBackButton if automaticallyImplyLeading is true
  final Widget? leading;

  /// List of action widgets to display at the end of the app bar
  final List<Widget>? actions;

  /// The bottom widget to display at the bottom of the app bar
  final PreferredSizeWidget? bottom;

  /// Whether to center the title
  final bool? centerTitle;

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

  /// The size of the app bar when it is fully expanded
  final double? expandedHeight;

  /// A widget to display in the flexible space of the app bar
  final Widget? flexibleSpace;

  /// Whether the app bar should remain visible at the start of the scroll view
  final bool pinned;

  /// Whether the app bar should become visible as soon as the user scrolls towards the app bar
  final bool floating;

  /// Whether the app bar should snap into view
  final bool snap;

  /// Whether the app bar should stretch to fill the over-scroll area
  final bool stretch;

  /// The offset of overscroll required to activate the stretch trigger
  final double stretchTriggerOffset;

  /// The callback function to be executed when a stretch trigger is activated
  final Future<void> Function()? onStretchTrigger;

  /// Whether to force the app bar to have elevation regardless of whether it has content under it
  final bool forceElevated;

  /// The content will be clipped (or not) according to this option
  final Clip? clipBehavior;

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

    return SliverAppBar(
      title: title,
      leading: shouldShowLeading ? (leading ?? ModernBackButton(onTap: onBackButtonTap)) : null,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
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
            systemNavigationBarIconBrightness: isLightTheme ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
          ),
      bottom: bottom,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace != null
          ? ClipRect(
              child: RepaintBoundary(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor ?? defaultBackgroundColor,
                    ),
                    child: flexibleSpace,
                  ),
                ),
              ),
            )
          : ClipRect(
              child: RepaintBoundary(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor ?? defaultBackgroundColor,
                    ),
                  ),
                ),
              ),
            ),
      pinned: pinned,
      floating: floating,
      snap: snap,
      stretch: stretch,
      stretchTriggerOffset: stretchTriggerOffset,
      onStretchTrigger: onStretchTrigger,
      forceElevated: forceElevated,
      clipBehavior: clipBehavior,
    );
  }
}
