import 'package:flutter/material.dart';
import 'package:flutter_components/component_blurred_app_bar.dart';
import 'package:flutter_components/component_close_button.dart';
import 'package:flutter_components/component_modal_controller.dart';
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
  static Future<T?> showWithScaffold<T>({
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
  static Future<T?> show<T>({
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
                resizeToAvoidBottomInset: false,
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
        // Transparent sheet Material still paints theme elevation; kill it so
        // it doesn't show as a ghost behind the inset card.
        elevation: float ? 0 : null,
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

  /// [show] with app bar actions that the widget in the modal's body can drive,
  /// so validation and submit logic live inside that widget instead of at the
  /// call site.
  ///
  /// Deliberately a separate entry point while it is being adopted; [show] is
  /// unchanged and can forward to this once it has proven itself.
  ///
  /// - [actions] are app bar actions owned entirely by the call site
  /// - [actionsBuilder] builds app bar actions from the modal's
  ///   [ComponentModalController]. They rebuild whenever the body changes what
  ///   the controller reports, and are appended after [actions]
  /// - [animationStyle] defaults to `AppDecoration.smoothSheetAnimationStyle`
  ///
  /// ```dart
  /// final profile = await ComponentResponsiveModal.showWithActions<Profile>(
  ///   context: context,
  ///   title: 'Edit profile',
  ///   actionsBuilder: (context, modal) => [
  ///     TextButton(
  ///       onPressed: modal.isEnabled ? modal.invoke : null,
  ///       child: modal.isBusy ? const CupertinoActivityIndicator() : const Text('Save'),
  ///     ),
  ///   ],
  ///   builder: (context) => const EditProfileForm(),
  /// );
  /// ```
  ///
  /// `EditProfileForm` claims the action from its `build` with
  /// `ComponentModalScope.of(context).attach(onInvoke: _save, isEnabled: _isValid)`
  /// and closes the modal by returning `ComponentModalAction.close(profile)`.
  static Future<T?> showWithActions<T>({
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
    List<Widget> Function(BuildContext context, ComponentModalController modal)? actionsBuilder,
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
        pageBuilder: (dialogContext, animation, secondaryAnimation) => _ComponentModalShell(
          builder: (_, modal) => Dialog(
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
                  resizeToAvoidBottomInset: false,
                  backgroundColor: context.bottomSheetTheme.backgroundColor,
                  appBar: ComponentBlurredAppBar(
                    context: context,
                    borderRadius: const BorderRadius.vertical(top: AppDecoration.iOSModalRadius),
                    toolbarHeight: kModalToolbarHeight,
                    actions: _resolveActions(actions, actionsBuilder, modal),
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
        // Transparent sheet Material still paints theme elevation; kill it so
        // it doesn't show as a ghost behind the inset card.
        elevation: float ? 0 : null,
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
          return _ComponentModalShell(
            builder: (_, modal) {
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
                    // For fixed-height sheets the whole sheet is lifted below,
                    // so the Scaffold must not also consume the inset.
                    // Full-height sheets rely on the Scaffold resizing its body.
                    resizeToAvoidBottomInset: !hasFixedHeight,
                    extendBodyBehindAppBar: true,
                    backgroundColor: context.bottomSheetTheme.backgroundColor,
                    appBar: ComponentBlurredAppBar(
                      context: context,
                      borderRadius: const BorderRadius.vertical(top: AppDecoration.iOSModalRadius),
                      toolbarHeight: kModalToolbarHeight,
                      actions: _resolveActions(actions, actionsBuilder, modal),
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
        },
      );
    }
  }
}

/// Merges the call site's [actions] with the actions built from the modal's
/// [ComponentModalController], rebuilding the latter whenever the widget in the
/// modal's body changes what the controller reports.
List<Widget>? _resolveActions(
  List<Widget>? actions,
  List<Widget> Function(BuildContext context, ComponentModalController modal)? actionsBuilder,
  ComponentModalController modal,
) {
  final builder = actionsBuilder;
  if (builder == null) return actions;

  return [
    ...?actions,
    ListenableBuilder(
      listenable: modal,
      builder: (context, _) =>
          Row(mainAxisSize: MainAxisSize.min, children: builder(context, modal)),
    ),
  ];
}

/// Owns the [ComponentModalController] of one modal route and publishes it to the
/// widget shown in the modal's body.
class _ComponentModalShell extends StatefulWidget {
  const _ComponentModalShell({required this.builder});

  final Widget Function(BuildContext context, ComponentModalController modal) builder;

  @override
  State<_ComponentModalShell> createState() => _ComponentModalShellState();
}

class _ComponentModalShellState extends State<_ComponentModalShell> {
  late final ComponentModalController _controller = ComponentModalController(onClose: _close);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close(Object? result) {
    // The controller can outlive the route by the length of an in-flight handler.
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return ComponentModalScope(
      controller: _controller,
      // The body is built below the scope, so its state can look the controller
      // up even though [builder] is called with the context above it.
      child: widget.builder(context, _controller),
    );
  }
}
