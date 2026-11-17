import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter_components/component_slide_down_bar.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/bottom_sheet_extent.dart';
import 'package:flutter_components/shared/modal_chrome.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

const double _kPhoneFloatInset = 12;
const double _kLargeScreenInset = 24;
const double _kDefaultMaxWidth = 480;
const Duration _kKeyboardLiftDuration = Duration(milliseconds: 200);

/// Horizontal resting place of a [ComponentBottomSheet] on screens wider than a phone.
enum ComponentBottomSheetPlacement { left, center, right }

/// Drives snap points and closing for an open [ComponentBottomSheet].
///
/// Pass the same instance to [ComponentBottomSheet.show]. Methods are no-ops
/// until the sheet has been presented.
class ComponentBottomSheetController {
  BottomSheetExtent? _extent;

  bool get isAttached => _extent != null;

  int get snapIndex => _extent?.snapIndex ?? 0;

  void snapTo(int index) => _extent?.snapTo(index);

  void expand() => _extent?.expand();

  void collapse() => _extent?.collapse();

  void close([Object? result]) => _extent?.close(result);

  void _attach(BottomSheetExtent extent) {
    assert(_extent == null, 'ComponentBottomSheetController is already attached to a sheet.');
    _extent = extent;
  }

  void _detach(BottomSheetExtent extent) {
    if (_extent != extent) return;
    _extent = null;
  }
}

/// A modal sheet that snaps, floats, and stays a sheet on large screens.
///
/// Return a [ComponentResponsiveModalWidget] from [show]'s `builder` so the
/// sheet uses the same app bar as [ComponentResponsiveModal].
class ComponentBottomSheet {
  /// Presents a modal sheet that slides up from the bottom on every screen size.
  ///
  /// [snapPoints] are fractions of the available height. When omitted, the sheet
  /// sizes itself to its content up to 90% of that height. On phones, [float]
  /// insets the sheet and rounds every corner; on larger screens the sheet
  /// always floats and [placement] chooses left, center, or right.
  ///
  /// ```dart
  /// final name = await ComponentBottomSheet.show<String>(
  ///   context: context,
  ///   snapPoints: const [0.5, 0.9],
  ///   builder: (context) => const EditNameForm(),
  /// );
  /// ```
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
    List<double>? snapPoints,
    int initialSnapIndex = 0,
    bool float = false,
    ComponentBottomSheetPlacement placement = .center,
    double maxWidth = _kDefaultMaxWidth,
    bool showHandle = false,
    bool expandOnKeyboard = false,
    ComponentBottomSheetController? controller,
    ValueChanged<int>? onSnapChanged,
    bool enableDrag = true,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    AnimationStyle? animationStyle,
  }) {
    assert(
      snapPoints == null || snapPoints.every((double point) => point > 0 && point <= 1),
      'snapPoints must be fractions in (0, 1]',
    );
    assert(
      snapPoints == null || (initialSnapIndex >= 0 && initialSnapIndex < snapPoints.length),
      'initialSnapIndex is out of range',
    );

    final AnimationStyle resolvedAnimation =
        animationStyle ?? AppDecoration.smoothSheetAnimationStyle;
    return Navigator.of(context, rootNavigator: useRootNavigator).push(
      _BottomSheetRoute<T>(
        builder: builder,
        snapPoints: snapPoints,
        initialSnapIndex: initialSnapIndex,
        float: float,
        placement: placement,
        maxWidth: maxWidth,
        showHandle: showHandle,
        expandOnKeyboard: expandOnKeyboard,
        sheetController: controller,
        onSnapChanged: onSnapChanged,
        enableDrag: enableDrag,
        barrierDismissible: barrierDismissible,
        animationStyle: resolvedAnimation,
        capturedAvailableHeight: _initialAvailableHeight(context),
        barrierColor: modalBarrierColor(context),
      ),
    );
  }

  static double _initialAvailableHeight(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    return math.max(0, size.height - padding.top);
  }
}

class _BottomSheetRoute<T> extends PopupRoute<T> {
  _BottomSheetRoute({
    required this.builder,
    required this.snapPoints,
    required this.initialSnapIndex,
    required this.float,
    required this.placement,
    required this.maxWidth,
    required this.showHandle,
    required this.expandOnKeyboard,
    required this.sheetController,
    required this.onSnapChanged,
    required this.enableDrag,
    required this.barrierDismissible,
    required this.animationStyle,
    required this.capturedAvailableHeight,
    required this._barrierColor,
  });

  final Widget Function(BuildContext context) builder;
  final List<double>? snapPoints;
  final int initialSnapIndex;
  final bool float;
  final ComponentBottomSheetPlacement placement;
  final double maxWidth;
  final bool showHandle;
  final bool expandOnKeyboard;
  final ComponentBottomSheetController? sheetController;
  final ValueChanged<int>? onSnapChanged;
  final bool enableDrag;
  @override
  final bool barrierDismissible;
  final AnimationStyle animationStyle;
  final double capturedAvailableHeight;
  final Color _barrierColor;

  bool skipReverseAnimation = false;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => _barrierColor;

  @override
  String get barrierLabel => '';

  @override
  Duration get transitionDuration => animationStyle.duration ?? const Duration(milliseconds: 400);

  @override
  Duration get reverseTransitionDuration => skipReverseAnimation
      ? Duration.zero
      : (animationStyle.reverseDuration ?? const Duration(milliseconds: 300));

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _SheetPage<T>(
      builder: builder,
      snapPoints: snapPoints,
      initialSnapIndex: initialSnapIndex,
      float: float,
      placement: placement,
      maxWidth: maxWidth,
      showHandle: showHandle,
      expandOnKeyboard: expandOnKeyboard,
      controller: sheetController,
      onSnapChanged: onSnapChanged,
      enableDrag: enableDrag,
      capturedAvailableHeight: capturedAvailableHeight,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final Curve curve = animation.status == AnimationStatus.reverse
        ? (animationStyle.reverseCurve ?? Curves.fastEaseInToSlowEaseOut)
        : (animationStyle.curve ?? Curves.easeIn);
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: curve)),
      ),
      child: child,
    );
  }
}

class _SheetPage<T> extends StatefulWidget {
  const _SheetPage({
    required this.builder,
    required this.snapPoints,
    required this.initialSnapIndex,
    required this.float,
    required this.placement,
    required this.maxWidth,
    required this.showHandle,
    required this.expandOnKeyboard,
    required this.controller,
    required this.onSnapChanged,
    required this.enableDrag,
    required this.capturedAvailableHeight,
  });

  final Widget Function(BuildContext context) builder;
  final List<double>? snapPoints;
  final int initialSnapIndex;
  final bool float;
  final ComponentBottomSheetPlacement placement;
  final double maxWidth;
  final bool showHandle;
  final bool expandOnKeyboard;
  final ComponentBottomSheetController? controller;
  final ValueChanged<int>? onSnapChanged;
  final bool enableDrag;
  final double capturedAvailableHeight;

  @override
  State<_SheetPage<T>> createState() => _SheetPageState<T>();
}

class _SheetPageState<T> extends State<_SheetPage<T>> with TickerProviderStateMixin {
  late final BottomSheetExtent _extent;
  late final BottomSheetScrollController _scrollController;
  bool _keyboardWasOpen = false;
  double _scheduledHeight = -1;
  double _scheduledKeyboard = -1;

  @override
  void initState() {
    super.initState();
    _extent = BottomSheetExtent(
      snapPoints: widget.snapPoints,
      availableHeight: widget.capturedAvailableHeight,
      initialSnapIndex: widget.initialSnapIndex,
      enableDrag: widget.enableDrag,
      onSnapChanged: widget.onSnapChanged,
      onClose: _close,
    );
    _extent.bindTickerProvider(this);
    _scrollController = BottomSheetScrollController(extent: _extent);
    widget.controller?._attach(_extent);
  }

  @override
  void dispose() {
    widget.controller?._detach(_extent);
    _scrollController.dispose();
    _extent.dispose();
    super.dispose();
  }

  void _close(Object? result) {
    if (!mounted) return;
    final ModalRoute<dynamic>? route = ModalRoute.of(context);
    if (route is _BottomSheetRoute<T> && _extent.dismissOffset > 1) {
      route.skipReverseAnimation = true;
    }
    Navigator.of(context).pop(result);
  }

  void _scheduleAvailableHeight(double height, double keyboard) {
    if ((height - _scheduledHeight).abs() < 0.5 && (keyboard - _scheduledKeyboard).abs() < 0.5) {
      return;
    }
    _scheduledHeight = height;
    _scheduledKeyboard = keyboard;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bool keyboardOpen = keyboard > 0;
      final bool expand = widget.expandOnKeyboard && keyboardOpen && !_keyboardWasOpen;
      _keyboardWasOpen = keyboardOpen;
      _extent.updateAvailableHeight(height, expand: expand);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    final bool floats = !isMobile || widget.float;
    final double inset = isMobile ? _kPhoneFloatInset : _kLargeScreenInset;
    final double keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final double safeBottom = MediaQuery.paddingOf(context).bottom;
    final double bottom = floats ? math.max(keyboard, math.max(safeBottom, inset)) : keyboard;
    final EdgeInsets framePadding = EdgeInsets.only(
      left: floats ? inset : 0,
      right: floats ? inset : 0,
      bottom: bottom,
    );
    final Alignment alignment = isMobile
        ? Alignment.bottomCenter
        : switch (widget.placement) {
            .left => Alignment.bottomLeft,
            .center => Alignment.bottomCenter,
            .right => Alignment.bottomRight,
          };
    final double sheetMaxWidth = isMobile && !widget.float ? double.infinity : widget.maxWidth;
    final BorderRadius borderRadius = floats
        ? AppDecoration.iOSModalBorderRadius
        : kModalTopBorderRadius;
    final BorderSide side = floats && context.isDarkMode
        ? BorderSide(color: context.borderColor)
        : BorderSide.none;

    return AnimatedPadding(
      duration: _kKeyboardLiftDuration,
      curve: Curves.easeOut,
      padding: framePadding,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          _scheduleAvailableHeight(constraints.maxHeight, keyboard);
          return Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: sheetMaxWidth,
                maxHeight: constraints.maxHeight,
              ),
              child: ListenableBuilder(
                listenable: _extent,
                builder: (BuildContext context, Widget? child) {
                  return Transform.translate(
                    offset: Offset(0, _extent.dismissOffset),
                    child: _extent.isContentSized
                        ? ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: constraints.maxHeight * kBottomSheetContentMaxFraction,
                            ),
                            child: child,
                          )
                        : SizedBox(
                            height: _extent.extent,
                            width: double.infinity,
                            child: child,
                          ),
                  );
                },
                child: _buildSheet(
                  context: context,
                  floats: floats,
                  borderRadius: borderRadius,
                  side: side,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSheet({
    required BuildContext context,
    required bool floats,
    required BorderRadius borderRadius,
    required BorderSide side,
  }) {
    final Widget body = ComponentBottomSheetScope(
      scrollController: _scrollController,
      shrinkWrap: _extent.isContentSized,
      extent: _extent,
      padBottomSafeArea: !floats,
      handle: widget.showHandle
          ? _SheetHandle(extent: _extent, enableDrag: widget.enableDrag)
          : null,
      child: widget.builder(context),
    );

    Widget sheet = Material(
      key: const ValueKey<String>('component-bottom-sheet'),
      color: context.bottomSheetTheme.backgroundColor,
      elevation: floats ? 8 : 0,
      shadowColor: Colors.transparent,
      shape: RoundedSuperellipseBorder(borderRadius: borderRadius, side: side),
      clipBehavior: .antiAlias,
      child: clipModalChrome(
        borderRadius: borderRadius,
        child: MediaQuery.removeViewInsets(
          context: context,
          removeBottom: true,
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: floats,
            child: RepaintBoundary(child: body),
          ),
        ),
      ),
    );

    if (_extent.isContentSized) {
      sheet = _ReportSize(
        onSize: (Size size) => _extent.updateContentHeight(size.height),
        child: sheet,
      );
    }

    return SizedBox(width: double.infinity, child: sheet);
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle({required this.extent, required this.enableDrag});

  final BottomSheetExtent extent;
  final bool enableDrag;

  @override
  Widget build(BuildContext context) {
    const ValueKey<String> key = ValueKey<String>('component-bottom-sheet-handle');
    const Widget handle = Padding(
      padding: EdgeInsets.only(top: 10, bottom: 6),
      child: Center(child: ComponentSlideDownBar()),
    );
    if (!enableDrag) return const KeyedSubtree(key: key, child: handle);
    return GestureDetector(
      key: key,
      behavior: .opaque,
      onVerticalDragUpdate: (DragUpdateDetails details) {
        extent.applyDragDelta(details.delta.dy);
      },
      onVerticalDragEnd: (DragEndDetails details) {
        extent.settle(expandVelocity: -details.velocity.pixelsPerSecond.dy);
      },
      child: handle,
    );
  }
}

class _ReportSize extends SingleChildRenderObjectWidget {
  const _ReportSize({required this.onSize, required super.child});

  final ValueChanged<Size> onSize;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderReportSize(onSize);

  @override
  void updateRenderObject(BuildContext context, covariant _RenderReportSize renderObject) {
    renderObject.onSize = onSize;
  }
}

class _RenderReportSize extends RenderProxyBox {
  _RenderReportSize(this.onSize);

  ValueChanged<Size> onSize;
  Size? _last;

  @override
  void performLayout() {
    super.performLayout();
    if (size == _last) return;
    _last = size;
    final Size reported = size;
    WidgetsBinding.instance.addPostFrameCallback((_) => onSize(reported));
  }
}
