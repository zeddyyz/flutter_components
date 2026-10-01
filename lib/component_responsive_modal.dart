import 'package:flutter_components/component_blurred_app_bar.dart';
import 'package:flutter_components/component_close_button.dart';
import 'package:flutter_components/component_modal_controller.dart';
import 'package:flutter_components/component_responsive_modal_widget.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

const double kModalToolbarHeight = 65;

const BorderRadius _kModalTopBorderRadius = BorderRadius.vertical(
  top: AppDecoration.iOSModalRadius,
);

/// Shows either a modal bottom sheet (on small screens) or a dialog (on larger screens)
class ComponentResponsiveModal {
  static Future<T?> showFullScreen<T>({
    required BuildContext context,
    required Widget child,
  }) async {
    return await showGeneralDialog<T>(
      context: context,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: _slideUpTransition,
      pageBuilder: (context, animation1, animation2) => child,
    );
  }

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
    final bool isLargeScreen = !context.isMobile;
    final Color? bgColor = Theme.of(context).bottomSheetTheme.backgroundColor;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double viewHeight = MediaQuery.sizeOf(context).height;

    if (isLargeScreen) {
      return showDialog<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        barrierDismissible: barrierDismissible,
        barrierColor: _barrierColor(context),
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
                    actionsPadding: const EdgeInsets.only(right: 20),
                    actions: const [ComponentCloseButton()],
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
    }

    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: barrierDismissible,
      backgroundColor: bgColor,
      barrierColor: _barrierColor(context),
      shape: RoundedSuperellipseBorder(
        borderRadius: const BorderRadius.only(
          topLeft: AppDecoration.iOSModalRadius,
          topRight: AppDecoration.iOSModalRadius,
        ),
      ),
      constraints:
          constraints ?? BoxConstraints(minHeight: viewHeight * 0.3, maxHeight: viewHeight * 0.8),
      builder: (BuildContext bottomSheetContext) {
        final Widget scaffold = Scaffold(
          appBar: AppBar(
            title: Padding(padding: const EdgeInsets.only(left: 8), child: Text(title)),
            titleTextStyle: textTheme.headlineMedium,
            automaticallyImplyLeading: false,
            centerTitle: false,
            toolbarHeight: 65,
            actionsPadding: const EdgeInsets.only(right: 10),
            actions: const [ComponentCloseButton()],
          ),
          body: isScrollable
              ? SingleChildScrollView(child: builder(bottomSheetContext, true))
              : builder(bottomSheetContext, true),
        );

        if (isFloating) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: MediaQuery.of(context).padding.bottom,
            ),
            child: ClipRSuperellipse(
              borderRadius: AppDecoration.iOSModalBorderRadius,
              child: scaffold,
            ),
          );
        }

        return ClipRSuperellipse(
          borderRadius: AppDecoration.iOSModalBorderRadius,
          child: scaffold,
        );
      },
    );
  }

  /// - [animationStyle] defaults to `AppDecoration.smoothSheetAnimationStyle`
  /// - [showAppBar] shows the close button and title. Defaults to true.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget Function(BuildContext context) builder,
    BoxConstraints? constraints,
    bool isScrollable = true,
    bool useRootNavigator = true,
    bool barrierDismissible = true,
    bool float = false,
    bool showAppBar = true,
    AnimationStyle? animationStyle,
    List<Widget>? actions,
  }) {
    return _present<T>(
      context: context,
      constraints: constraints,
      isScrollable: isScrollable,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      float: float,
      animationStyle: animationStyle,
      builder: (BuildContext routeContext) {
        return _ModalFrame(
          context: context,
          routeContext: routeContext,
          constraints: constraints,
          float: float,
          removeTopDialogViewPadding: true,
          child: Scaffold(
            extendBodyBehindAppBar: showAppBar,
            resizeToAvoidBottomInset: !_hasFixedHeight(constraints),
            backgroundColor: context.bottomSheetTheme.backgroundColor,
            appBar: showAppBar
                ? _modalBlurredAppBar(
                    context: context,
                    title: title,
                    actions: actions,
                  )
                : null,
            body: builder(routeContext),
          ),
        );
      },
    );
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
    return _present<T>(
      context: context,
      constraints: constraints,
      isScrollable: isScrollable,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      float: float,
      animationStyle: animationStyle,
      builder: (BuildContext routeContext) {
        return _ComponentModalShell(
          builder: (_, ComponentModalController modal) {
            return _ModalFrame(
              context: context,
              routeContext: routeContext,
              constraints: constraints,
              float: float,
              removeTopDialogViewPadding: true,
              child: Scaffold(
                extendBodyBehindAppBar: true,
                resizeToAvoidBottomInset: !_hasFixedHeight(constraints),
                backgroundColor: context.bottomSheetTheme.backgroundColor,
                appBar: _modalBlurredAppBar(
                  context: context,
                  title: title,
                  actions: _resolveActions(actions, actionsBuilder, modal),
                ),
                body: builder(routeContext),
              ),
            );
          },
        );
      },
    );
  }

  /// [show] for content that renders its own app bar, so the app bar actions
  /// are built from the content's state and need no [ComponentModalController].
  ///
  /// [builder] returns the widget shown in the modal, whose `build` returns a
  /// [ComponentResponsiveModalWidget] with the title, the app bar actions and
  /// the slivers. The content closes the modal, optionally with a result, with
  /// `Navigator.pop(context, result)`.
  ///
  /// - [animationStyle] defaults to `AppDecoration.smoothSheetAnimationStyle`
  ///
  /// ```dart
  /// final name = await ComponentResponsiveModal.showWithActionsSimple<String>(
  ///   context: context,
  ///   builder: (context) => const EditNameForm(),
  /// );
  /// ```
  static Future<T?> showWithActionsSimple<T>({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
    BoxConstraints? constraints,
    bool isScrollable = true,
    bool useRootNavigator = true,
    bool barrierDismissible = true,
    bool float = false,
    AnimationStyle? animationStyle,
  }) {
    return _present<T>(
      context: context,
      constraints: constraints,
      isScrollable: isScrollable,
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      float: float,
      animationStyle: animationStyle,
      builder: (BuildContext routeContext) {
        return _ModalFrame(
          context: context,
          routeContext: routeContext,
          constraints: constraints,
          float: float,
          removeAllDialogViewPadding: true,
          removeFloatingSheetBottomPadding: true,
          child: Scaffold(
            resizeToAvoidBottomInset: !_hasFixedHeight(constraints),
            backgroundColor: context.bottomSheetTheme.backgroundColor,
            body: builder(routeContext),
          ),
        );
      },
    );
  }
}

Future<T?> _present<T>({
  required BuildContext context,
  required Widget Function(BuildContext routeContext) builder,
  BoxConstraints? constraints,
  required bool isScrollable,
  required bool useRootNavigator,
  required bool barrierDismissible,
  required bool float,
  AnimationStyle? animationStyle,
}) {
  if (!context.isMobile) {
    return showGeneralDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierLabel: '',
      barrierDismissible: barrierDismissible,
      barrierColor: _barrierColor(context),
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: _slideUpTransition,
      pageBuilder: (BuildContext dialogContext, Animation<double> animation, Animation<double> secondaryAnimation) =>
          builder(dialogContext),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: useRootNavigator,
    useSafeArea: true,
    isScrollControlled: isScrollable,
    enableDrag: barrierDismissible,
    isDismissible: barrierDismissible,
    backgroundColor: float ? Colors.transparent : context.bottomSheetTheme.backgroundColor,
    elevation: float ? 0 : null,
    barrierColor: _barrierColor(context),
    shape: RoundedSuperellipseBorder(
      borderRadius: float ? AppDecoration.iOSModalBorderRadius : _kModalTopBorderRadius,
    ),
    sheetAnimationStyle: animationStyle ?? AppDecoration.smoothSheetAnimationStyle,
    constraints: constraints == null
        ? const BoxConstraints.expand()
        : BoxConstraints(maxWidth: constraints.maxWidth),
    builder: (BuildContext bottomSheetContext) {
      final Widget sheet = builder(bottomSheetContext);
      if (!_hasFixedHeight(constraints)) return sheet;
      return AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(bottomSheetContext).bottom),
        child: sheet,
      );
    },
  );
}

bool _hasFixedHeight(BoxConstraints? constraints) {
  return constraints != null && constraints.maxHeight.isFinite;
}

Color _barrierColor(BuildContext context) {
  return context.isLightMode ? Colors.black45 : Colors.black.withValues(alpha: 0.7);
}

Widget _slideUpTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final Tween<Offset> tween = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: Offset.zero,
  );
  return SlideTransition(
    position: animation.drive(
      tween.chain(
        CurveTween(
          curve: Curves.ease,
        ),
      ),
    ),
    child: child,
  );
}

PreferredSizeWidget _modalBlurredAppBar({
  required BuildContext context,
  required String title,
  List<Widget>? actions,
}) {
  return ComponentBlurredAppBar(
    context: context,
    borderRadius: _kModalTopBorderRadius,
    toolbarHeight: kModalToolbarHeight,
    actions: actions,
    leading: const _ModalCloseLeading(),
    title: Text(title, style: context.body2Heavy),
    centerTitle: true,
    backgroundColor: context.bottomSheetTheme.backgroundColor,
  );
}

class _ModalCloseLeading extends StatelessWidget {
  const _ModalCloseLeading();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: ComponentCloseButton.blurred(
            backgroundColor: context.bottomSheetCardColor,
          ),
        ),
      ],
    );
  }
}

class _ModalFrame extends StatelessWidget {
  const _ModalFrame({
    required this.context,
    required this.routeContext,
    required this.constraints,
    required this.float,
    required this.child,
    this.removeTopDialogViewPadding = false,
    this.removeAllDialogViewPadding = false,
    this.removeFloatingSheetBottomPadding = false,
  });

  final BuildContext context;
  final BuildContext routeContext;
  final BoxConstraints? constraints;
  final bool float;
  final Widget child;
  final bool removeTopDialogViewPadding;
  final bool removeAllDialogViewPadding;
  final bool removeFloatingSheetBottomPadding;

  @override
  Widget build(BuildContext _) {
    if (!context.isMobile) {
      return Dialog(
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
            context: routeContext,
            removeTop: removeTopDialogViewPadding || removeAllDialogViewPadding,
            removeBottom: removeAllDialogViewPadding,
            removeLeft: removeAllDialogViewPadding,
            removeRight: removeAllDialogViewPadding,
            child: child,
          ),
        ),
      );
    }

    return Container(
      margin: float
          ? EdgeInsets.only(left: 12, right: 12, bottom: context.mediaQueryPadding.bottom)
          : EdgeInsets.zero,
      constraints: constraints ?? const BoxConstraints.expand(),
      child: ClipRSuperellipse(
        borderRadius: float ? AppDecoration.iOSModalBorderRadius : _kModalTopBorderRadius,
        child: MediaQuery.removePadding(
          context: routeContext,
          removeBottom: removeFloatingSheetBottomPadding && float,
          child: child,
        ),
      ),
    );
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
