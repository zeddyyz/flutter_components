import 'package:flutter/material.dart';
import 'package:flutter_components/component_blurred_app_bar.dart';
import 'package:flutter_components/component_close_button.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

const double kModalToolbarHeight = 65;

/// Shows either a modal bottom sheet (on small screens) or a dialog (on larger screens)
class ComponentResponsiveModal {
  ///
  /// Parameters:
  /// - [context]: BuildContext
  /// - [title]: Title of the modal
  /// - [builder]: Builder function that returns the content
  /// - [constraints]: Optional constraints for the modal
  /// - [isScrollable]: Whether the content should be scrollable
  /// - [useRootNavigator]: Use root navigator
  /// - [barrierDismissible]: Whether clicking outside dismisses the modal (dialog mode only)
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget Function(BuildContext, bool isDialog) builder,
    BoxConstraints? constraints,
    bool isScrollable = true,
    bool useRootNavigator = true,
    bool barrierDismissible = true,
    bool isFloating = false,
  }) {
    // Use MediaQuery to determine if we should show a dialog or bottom sheet
    final isLargeScreen = MediaQuery.sizeOf(context).width >= 635;
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final bgColor = Theme.of(context).bottomSheetTheme.backgroundColor;
    final textTheme = Theme.of(context).textTheme;
    final viewHeight = MediaQuery.sizeOf(context).height;

    if (isLargeScreen) {
      // Show as dialog on larger screens
      return showDialog<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        barrierDismissible: barrierDismissible,
        barrierColor: isLightMode ? Colors.black45 : Colors.black54,
        builder: (BuildContext dialogContext) {
          return Dialog(
            backgroundColor: bgColor,
            shadowColor: Colors.transparent,
            shape: RoundedSuperellipseBorder(
              borderRadius: AppDecoration.iOSModalBorderRadius,
            ),
            child: ClipRSuperellipse(
              borderRadius: AppDecoration.iOSModalBorderRadius,
              child: Container(
                constraints:
                    constraints ?? BoxConstraints(maxWidth: 560, maxHeight: viewHeight * 0.8),
                child: Scaffold(
                  appBar: AppBar(
                    title: Padding(padding: const EdgeInsets.only(left: 8), child: Text(title)),
                    titleTextStyle: textTheme.displayMedium,
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    toolbarHeight: 80,
                    actionsPadding: EdgeInsets.only(right: 20),
                    actions: [ComponentCloseButton()],
                  ),
                  body: isScrollable
                      ? SingleChildScrollView(child: builder(dialogContext, true))
                      : builder(dialogContext, true),
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Show as bottom sheet on smaller screens
      return showModalBottomSheet<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        useSafeArea: true,
        isScrollControlled: true,
        enableDrag: barrierDismissible,
        backgroundColor: bgColor,
        barrierColor: isLightMode ? Colors.black45 : Colors.black54,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.only(
            topLeft: AppDecoration.iOSModalRadius,
            topRight: AppDecoration.iOSModalRadius,
          ),
        ),
        constraints:
            constraints ?? BoxConstraints(minHeight: viewHeight * 0.3, maxHeight: viewHeight * 0.8),
        builder: (BuildContext bottomSheetContext) {
          if (isFloating) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: MediaQuery.of(context).padding.bottom,
              ),
              child: ClipRSuperellipse(
                borderRadius: AppDecoration.iOSModalBorderRadius,
                child: Scaffold(
                  appBar: AppBar(
                    title: Padding(padding: const EdgeInsets.only(left: 8), child: Text(title)),
                    titleTextStyle: textTheme.headlineMedium,
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    toolbarHeight: 65,
                    actionsPadding: EdgeInsets.only(right: 10),
                    actions: [ComponentCloseButton()],
                  ),
                  body: isScrollable
                      ? SingleChildScrollView(child: builder(bottomSheetContext, true))
                      : builder(bottomSheetContext, true),
                ),
              ),
            );
          }
          return ClipRSuperellipse(
            borderRadius: AppDecoration.iOSModalBorderRadius,
            child: Scaffold(
              appBar: AppBar(
                title: Padding(padding: const EdgeInsets.only(left: 8), child: Text(title)),
                titleTextStyle: textTheme.headlineMedium,
                automaticallyImplyLeading: false,
                centerTitle: false,
                toolbarHeight: 65,
                actionsPadding: EdgeInsets.only(right: 10),
                actions: [ComponentCloseButton()],
              ),
              body: isScrollable
                  ? SingleChildScrollView(child: builder(bottomSheetContext, true))
                  : builder(bottomSheetContext, true),
            ),
          );
        },
      );
    }
  }

  /// - [animationStyle] defaults to `AppDecoration.smoothSheetAnimationStyle`
  static Future<T?> showWithoutScaffold<T>({
    required BuildContext context,
    required String title,
    required Widget Function(BuildContext context) builder,
    BoxConstraints? constraints,
    bool isScrollable = true,
    bool useRootNavigator = true,
    bool barrierDismissible = true,
    bool float = false,
    AnimationStyle? animationStyle,
    List<Widget>? actions,
  }) {
    // Use MediaQuery to determine if we should show a dialog or bottom sheet
    final isLargeScreen = !context.isMobile;

    if (isLargeScreen) {
      // Show as dialog on larger screens
      return showGeneralDialog<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        barrierLabel: '',
        barrierDismissible: barrierDismissible,
        barrierColor: context.isLightMode ? Colors.black45 : Colors.black.withValues(alpha: 0.7),
        transitionDuration: const Duration(milliseconds: 400),
        transitionBuilder: (context, anim1, anim2, child) {
          final tween = Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          );
          return SlideTransition(
            position: anim1.drive(
              tween.chain(
                CurveTween(
                  curve: Curves.ease,
                ),
              ),
            ),
            child: child,
          );
        },
        pageBuilder: (dialogContext, animation, secondaryAnimation) => Dialog(
          backgroundColor: context.bottomSheetTheme.backgroundColor,
          shadowColor: Colors.transparent,
          elevation: 8,
          insetAnimationCurve: Curves.ease,
          insetAnimationDuration: const Duration(milliseconds: 400),
          shape: RoundedSuperellipseBorder(
            borderRadius: AppDecoration.iOSModalBorderRadius,
            side: context.isLightMode ? BorderSide.none : BorderSide(color: context.borderColor),
          ),
          constraints:
              constraints ??
              BoxConstraints(
                maxWidth: constraints?.maxWidth ?? 560,
                maxHeight: constraints?.maxHeight ?? context.viewHeight * 0.8,
              ),
          child: ClipRSuperellipse(
            borderRadius: AppDecoration.iOSModalBorderRadius,
            child: MediaQuery.removeViewPadding(
              context: dialogContext,
              removeTop: true,
              child: Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: context.bottomSheetTheme.backgroundColor,
                appBar: ComponentBlurredAppBar(
                  context: context,
                  borderRadius: const BorderRadius.vertical(top: AppDecoration.iOSModalRadius),
                  toolbarHeight: kModalToolbarHeight,
                  actions: actions,
                  leading: Row(
                    mainAxisSize: .min,
                    mainAxisAlignment: .start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 14),
                        child: ComponentCloseButton.blurred(
                          bgColor: context.bottomSheetCardColor,
                        ),
                      ),
                    ],
                  ),
                  title: Text(title, style: context.body2Heavy),
                  centerTitle: true,
                  backgroundColor: context.bottomSheetTheme.backgroundColor,
                ),
                body: builder(dialogContext),
              ),
            ),
          ),
        ),
      );
    } else {
      // Show as bottom sheet on smaller screens
      return showModalBottomSheet<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        useSafeArea: true,
        isScrollControlled: isScrollable,
        enableDrag: barrierDismissible,
        isDismissible: barrierDismissible,
        backgroundColor: float ? Colors.transparent : context.bottomSheetTheme.backgroundColor,
        barrierColor: context.isLightMode ? Colors.black45 : Colors.black.withValues(alpha: 0.7),
        shape: RoundedSuperellipseBorder(
          borderRadius: float
              ? AppDecoration.iOSModalBorderRadius
              : const BorderRadius.vertical(top: AppDecoration.iOSModalRadius),
        ),
        sheetAnimationStyle: animationStyle ?? AppDecoration.smoothSheetAnimationStyle,
        // When the caller pins a height, don't forward that height to
        // [showModalBottomSheet] (a pinned sheet can't slide above the
        // keyboard). Only forward the width; the fixed height is re-applied to
        // an inner box that we lift with the keyboard inset.
        constraints: constraints == null
            ? const BoxConstraints.expand()
            : BoxConstraints(maxWidth: constraints.maxWidth),
        builder: (BuildContext bottomSheetContext) {
          // A caller-provided height means the sheet is content/fixed sized and
          // should be lifted above the keyboard as a whole. Otherwise the sheet
          // is full-height and the inner Scaffold should resize its body.
          final bool hasFixedHeight = constraints != null && constraints.maxHeight.isFinite;
          final double keyboardInset = MediaQuery.viewInsetsOf(bottomSheetContext).bottom;
          final Widget sheet = Container(
            margin: float
                ? EdgeInsets.only(left: 12, right: 12, bottom: context.mediaQueryPadding.bottom)
                : EdgeInsets.zero,
            constraints: constraints ?? const BoxConstraints.expand(),
            child: ClipRSuperellipse(
              borderRadius: float
                  ? AppDecoration.iOSModalBorderRadius
                  : const BorderRadius.vertical(top: AppDecoration.iOSModalRadius),
              child: Scaffold(
                // For fixed-height sheets the whole sheet is lifted below, so
                // the Scaffold must not also consume the inset. Full-height
                // sheets rely on the Scaffold resizing its own body.
                resizeToAvoidBottomInset: !hasFixedHeight,
                extendBodyBehindAppBar: true,
                backgroundColor: context.bottomSheetTheme.backgroundColor,
                appBar: ComponentBlurredAppBar(
                  context: context,
                  borderRadius: const BorderRadius.vertical(top: AppDecoration.iOSModalRadius),
                  toolbarHeight: kModalToolbarHeight,
                  actions: actions,
                  leading: Row(
                    mainAxisSize: .min,
                    mainAxisAlignment: .start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 14),
                        child: ComponentCloseButton.blurred(bgColor: context.bottomSheetCardColor),
                      ),
                    ],
                  ),
                  title: Text(title, style: context.body2Heavy),
                  centerTitle: true,
                  backgroundColor: context.bottomSheetTheme.backgroundColor,
                ),
                body: builder(bottomSheetContext),
              ),
            ),
          );
          if (!hasFixedHeight) return sheet;
          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: keyboardInset),
            child: sheet,
          );
        },
      );
    }
  }
}
