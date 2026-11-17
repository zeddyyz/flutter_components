import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:material_ui/material_ui.dart';

/// Downward fling speed that dismisses a sheet that is already at its lowest snap.
const double kBottomSheetDismissVelocity = 700;

/// Fraction of the sheet's height the user must drag down to dismiss on release.
const double kBottomSheetDismissThreshold = 0.5;

/// Cap on a content-sized sheet, as a fraction of the available height.
const double kBottomSheetContentMaxFraction = 0.9;

/// Velocity above which a release prefers the next snap in that direction.
const double kBottomSheetSnapVelocity = 200;

const SpringDescription kBottomSheetSpring = SpringDescription(
  mass: 1,
  stiffness: 500,
  damping: 38,
);

/// Converts [snapPoints] (fractions of [availableHeight]) into sorted, unique pixel heights.
List<double> resolveSnapHeights({
  required List<double> snapPoints,
  required double availableHeight,
}) {
  assert(snapPoints.isNotEmpty, 'snapPoints must not be empty');
  assert(availableHeight >= 0, 'availableHeight must be >= 0');

  final List<double> heights = [
    for (final double point in snapPoints) (point * availableHeight).clamp(0.0, availableHeight),
  ]..sort();

  final List<double> unique = [];
  for (final double height in heights) {
    if (height <= 0) continue;
    if (unique.isEmpty || (height - unique.last).abs() > 0.5) {
      unique.add(height);
    }
  }
  return unique;
}

/// Index of the snap height nearest to [extent].
int nearestSnapIndex({
  required List<double> snapHeights,
  required double extent,
}) {
  assert(snapHeights.isNotEmpty, 'snapHeights must not be empty');
  int nearest = 0;
  double nearestDistance = (snapHeights.first - extent).abs();
  for (int i = 1; i < snapHeights.length; i++) {
    final double distance = (snapHeights[i] - extent).abs();
    if (distance < nearestDistance) {
      nearest = i;
      nearestDistance = distance;
    }
  }
  return nearest;
}

/// Snap index to settle at after a drag, biased by [velocity].
///
/// [velocity] is in extent space: positive expands the sheet, negative collapses it.
int targetSnapIndex({
  required List<double> snapHeights,
  required double extent,
  required double velocity,
  double velocityThreshold = kBottomSheetSnapVelocity,
}) {
  assert(snapHeights.isNotEmpty, 'snapHeights must not be empty');

  if (velocity.abs() <= velocityThreshold) {
    return nearestSnapIndex(snapHeights: snapHeights, extent: extent);
  }

  if (velocity > 0) {
    for (int i = 0; i < snapHeights.length; i++) {
      if (snapHeights[i] > extent + 0.5) return i;
    }
    return snapHeights.length - 1;
  }

  for (int i = snapHeights.length - 1; i >= 0; i--) {
    if (snapHeights[i] < extent - 0.5) return i;
  }
  return 0;
}

/// Whether a release should pop the sheet.
///
/// [downwardVelocity] is finger-down positive, matching a vertical drag's `dy`.
bool shouldDismissSheet({
  required double dismissOffset,
  required double sheetHeight,
  required double downwardVelocity,
}) {
  if (sheetHeight <= 0) return downwardVelocity >= kBottomSheetDismissVelocity;
  if (downwardVelocity >= kBottomSheetDismissVelocity) return true;
  return dismissOffset / sheetHeight >= kBottomSheetDismissThreshold;
}

/// Mutable height and dismiss translation of a [ComponentBottomSheet].
class BottomSheetExtent extends ChangeNotifier {
  BottomSheetExtent({
    List<double>? snapPoints,
    required double availableHeight,
    this.initialSnapIndex = 0,
    double? contentHeight,
    this.enableDrag = true,
    this.onSnapChanged,
    this.onClose,
  }) : _snapPoints = snapPoints,
       _availableHeight = availableHeight,
       _contentHeight = contentHeight ?? 0 {
    assert(
      snapPoints == null || snapPoints.isNotEmpty,
      'snapPoints must be null or non-empty',
    );
    assert(availableHeight >= 0, 'availableHeight must be >= 0');
    if (_snapPoints != null) {
      assert(
        initialSnapIndex >= 0 && initialSnapIndex < _snapPoints.length,
        'initialSnapIndex is out of range',
      );
    }
    _snapHeights = _resolveHeights();
    _extent = _initialExtent();
    _snapIndex = _snapHeights.isEmpty
        ? 0
        : nearestSnapIndex(snapHeights: _snapHeights, extent: _extent);
  }

  final List<double>? _snapPoints;
  final int initialSnapIndex;
  final bool enableDrag;
  final ValueChanged<int>? onSnapChanged;
  final ValueChanged<Object?>? onClose;

  double _availableHeight;
  double _contentHeight;
  late List<double> _snapHeights;
  late double _extent;
  double _dismissOffset = 0;
  late int _snapIndex;
  AnimationController? _animation;
  TickerProvider? _vsync;
  bool _isDisposed = false;

  bool get isContentSized => _snapPoints == null;

  double get availableHeight => _availableHeight;

  double get contentHeight => _contentHeight;

  List<double> get snapHeights => _snapHeights;

  double get minHeight =>
      isContentSized ? contentSizedHeight : (_snapHeights.isEmpty ? 0 : _snapHeights.first);

  double get maxHeight =>
      isContentSized ? contentSizedHeight : (_snapHeights.isEmpty ? 0 : _snapHeights.last);

  double get contentSizedHeight =>
      math.min(_contentHeight, _availableHeight * kBottomSheetContentMaxFraction);

  double get extent => isContentSized ? contentSizedHeight : _extent;

  double get dismissOffset => _dismissOffset;

  int get snapIndex => _snapIndex;

  bool get isAtMin => isContentSized || _extent <= minHeight + 0.5;

  bool get isAtMax => isContentSized || _extent >= maxHeight - 0.5;

  /// Visual sheet height used for dismiss math and layout.
  double get sheetHeight => extent;

  void bindTickerProvider(TickerProvider vsync) {
    _vsync = vsync;
  }

  void updateAvailableHeight(double availableHeight, {bool expand = false}) {
    if (_isDisposed) return;
    if ((availableHeight - _availableHeight).abs() < 0.5 && !expand) return;
    _availableHeight = availableHeight;
    _snapHeights = _resolveHeights();
    if (!isContentSized && _snapHeights.isNotEmpty) {
      if (expand) {
        _extent = maxHeight;
      } else {
        final int index = _snapIndex.clamp(0, _snapHeights.length - 1);
        _extent = _snapHeights[index];
      }
      _publishSnapIndex();
    }
    notifyListeners();
  }

  void updateContentHeight(double contentHeight) {
    if (_isDisposed) return;
    if ((contentHeight - _contentHeight).abs() < 0.5) return;
    _contentHeight = contentHeight;
    if (isContentSized) notifyListeners();
  }

  /// Applies a drag in [ScrollPosition.applyUserOffset] space: positive collapses.
  void applyDragDelta(double delta) {
    if (_isDisposed || !enableDrag || delta == 0) return;
    _stopAnimation();

    if (delta > 0) {
      _collapseBy(delta);
    } else {
      _expandBy(-delta);
    }
    _publishSnapIndex();
    notifyListeners();
  }

  /// Settles after a drag. [expandVelocity] is positive when the sheet should grow.
  void settle({TickerProvider? vsync, required double expandVelocity}) {
    if (_isDisposed || !enableDrag) return;
    final TickerProvider? ticks = vsync ?? _vsync;
    final double downwardVelocity = -expandVelocity;
    if (shouldDismissSheet(
      dismissOffset: _dismissOffset,
      sheetHeight: sheetHeight,
      downwardVelocity: isAtMin ? downwardVelocity : 0,
    )) {
      _dismiss(ticks, downwardVelocity);
      return;
    }

    if (_dismissOffset > 0) {
      if (ticks == null) {
        _dismissOffset = 0;
        notifyListeners();
        return;
      }
      _animate(
        vsync: ticks,
        from: _dismissOffset,
        to: 0,
        velocity: downwardVelocity,
        apply: _setDismissOffset,
      );
      return;
    }

    if (isContentSized || _snapHeights.isEmpty) return;

    final int index = targetSnapIndex(
      snapHeights: _snapHeights,
      extent: _extent,
      velocity: expandVelocity,
    );
    final double target = _snapHeights[index];
    if ((target - _extent).abs() < 0.5) {
      _setSnapIndex(index);
      return;
    }
    if (ticks == null) {
      _extent = target;
      _setSnapIndex(index);
      notifyListeners();
      return;
    }
    _animate(
      vsync: ticks,
      from: _extent,
      to: target,
      velocity: expandVelocity,
      apply: _setExtent,
      onDone: () => _setSnapIndex(index),
    );
  }

  void snapTo(int index, {TickerProvider? vsync}) {
    if (_isDisposed || isContentSized || _snapHeights.isEmpty) return;
    final int clamped = index.clamp(0, _snapHeights.length - 1);
    final double target = _snapHeights[clamped];
    _dismissOffset = 0;
    final TickerProvider? ticks = vsync ?? _vsync;
    if (ticks == null || (target - _extent).abs() < 0.5) {
      _stopAnimation();
      _extent = target;
      _setSnapIndex(clamped);
      notifyListeners();
      return;
    }
    _animate(
      vsync: ticks,
      from: _extent,
      to: target,
      velocity: 0,
      apply: _setExtent,
      onDone: () => _setSnapIndex(clamped),
    );
  }

  void expand({TickerProvider? vsync}) {
    if (isContentSized || _snapHeights.isEmpty) return;
    snapTo(_snapHeights.length - 1, vsync: vsync);
  }

  void collapse({TickerProvider? vsync}) {
    if (isContentSized || _snapHeights.isEmpty) return;
    snapTo(0, vsync: vsync);
  }

  void close([Object? result]) {
    if (_isDisposed) return;
    onClose?.call(result);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _vsync = null;
    _stopAnimation();
    super.dispose();
  }

  void _dismiss(TickerProvider? vsync, double downwardVelocity) {
    final double target = math.max(sheetHeight, 1);
    if (vsync == null) {
      _dismissOffset = target;
      notifyListeners();
      onClose?.call(null);
      return;
    }
    _animate(
      vsync: vsync,
      from: _dismissOffset,
      to: target,
      velocity: downwardVelocity,
      apply: _setDismissOffset,
      onDone: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isDisposed) return;
          onClose?.call(null);
        });
      },
    );
  }

  List<double> _resolveHeights() {
    if (_snapPoints == null) return const [];
    return resolveSnapHeights(snapPoints: _snapPoints, availableHeight: _availableHeight);
  }

  double _initialExtent() {
    if (isContentSized) return contentSizedHeight;
    if (_snapHeights.isEmpty) return 0;
    final int index = initialSnapIndex.clamp(0, _snapHeights.length - 1);
    return _snapHeights[index];
  }

  void _collapseBy(double delta) {
    if (!isContentSized && _extent > minHeight) {
      final double remaining = _extent - minHeight;
      if (delta <= remaining) {
        _extent -= delta;
        return;
      }
      _extent = minHeight;
      _dismissOffset += delta - remaining;
      return;
    }
    _dismissOffset += delta;
  }

  void _expandBy(double delta) {
    if (_dismissOffset > 0) {
      if (delta <= _dismissOffset) {
        _dismissOffset -= delta;
        return;
      }
      final double leftover = delta - _dismissOffset;
      _dismissOffset = 0;
      if (!isContentSized) {
        _extent = math.min(maxHeight, _extent + leftover);
      }
      return;
    }
    if (!isContentSized) {
      _extent = math.min(maxHeight, _extent + delta);
    }
  }

  void _setExtent(double value) {
    _extent = value.clamp(minHeight, maxHeight);
    notifyListeners();
  }

  void _setDismissOffset(double value) {
    _dismissOffset = math.max(0, value);
    notifyListeners();
  }

  void _publishSnapIndex() {
    if (_snapHeights.isEmpty) return;
    _setSnapIndex(nearestSnapIndex(snapHeights: _snapHeights, extent: _extent));
  }

  void _setSnapIndex(int index) {
    if (index == _snapIndex) return;
    _snapIndex = index;
    onSnapChanged?.call(index);
  }

  void _animate({
    required TickerProvider vsync,
    required double from,
    required double to,
    required double velocity,
    required void Function(double value) apply,
    VoidCallback? onDone,
  }) {
    _stopAnimation();
    final AnimationController controller = AnimationController.unbounded(
      vsync: vsync,
      value: from,
    );
    _animation = controller;
    controller.addListener(() => apply(controller.value));
    controller
        .animateWith(
          _ClampedSpringSimulation(
            spring: kBottomSheetSpring,
            start: from,
            end: to,
            velocity: velocity,
          ),
        )
        .whenComplete(() {
          if (_animation != controller) return;
          apply(to);
          _stopAnimation();
          onDone?.call();
        });
  }

  void _stopAnimation() {
    _animation?.dispose();
    _animation = null;
  }
}

/// [ScrollController] that resizes a [BottomSheetExtent] until a snap limit, then scrolls.
class BottomSheetScrollController extends ScrollController {
  BottomSheetScrollController({required this.extent});

  final BottomSheetExtent extent;

  @override
  BottomSheetScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return BottomSheetScrollPosition(
      physics: physics.applyTo(const AlwaysScrollableScrollPhysics()),
      context: context,
      oldPosition: oldPosition,
      extent: extent,
    );
  }

  @override
  BottomSheetScrollPosition get position => super.position as BottomSheetScrollPosition;
}

/// Scroll position that hands vertical drags to [BottomSheetExtent] until content should scroll.
class BottomSheetScrollPosition extends ScrollPositionWithSingleContext {
  BottomSheetScrollPosition({
    required super.physics,
    required super.context,
    super.oldPosition,
    required this.extent,
  });

  final BottomSheetExtent extent;
  VoidCallback? _dragCancelCallback;

  bool get _contentShouldScroll => pixels > 0.0;

  @override
  void absorb(ScrollPosition other) {
    super.absorb(other);
    if (other is BottomSheetScrollPosition) {
      _dragCancelCallback = other._dragCancelCallback;
      other._dragCancelCallback = null;
    }
  }

  @override
  void applyUserOffset(double delta) {
    if (!extent.enableDrag) {
      super.applyUserOffset(delta);
      return;
    }
    final bool shouldResize = !_contentShouldScroll && (!extent.isAtMax || delta > 0);
    if (shouldResize) {
      extent.applyDragDelta(delta);
      return;
    }
    super.applyUserOffset(delta);
  }

  @override
  void goBallistic(double velocity) {
    if (!extent.enableDrag) {
      super.goBallistic(velocity);
      return;
    }
    if ((velocity < 0.0 && _contentShouldScroll) || (velocity > 0.0 && extent.isAtMax)) {
      super.goBallistic(velocity);
      return;
    }
    _dragCancelCallback?.call();
    _dragCancelCallback = null;
    extent.settle(vsync: context.vsync, expandVelocity: velocity);
    super.goIdle();
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    _dragCancelCallback = dragCancelCallback;
    return super.drag(details, dragCancelCallback);
  }
}

/// Publishes the sheet's [ScrollController] and shrink-wrap flag to the modal body.
class ComponentBottomSheetScope extends InheritedWidget {
  const ComponentBottomSheetScope({
    super.key,
    required this.scrollController,
    required this.shrinkWrap,
    required this.extent,
    required this.padBottomSafeArea,
    this.handle,
    required super.child,
  });

  final ScrollController scrollController;
  final bool shrinkWrap;
  final BottomSheetExtent extent;
  final bool padBottomSafeArea;

  /// Grabber drawn inside the faded app bar when the sheet shows a handle.
  final Widget? handle;

  static ComponentBottomSheetScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ComponentBottomSheetScope>();
  }

  @override
  bool updateShouldNotify(ComponentBottomSheetScope oldWidget) {
    return scrollController != oldWidget.scrollController ||
        shrinkWrap != oldWidget.shrinkWrap ||
        padBottomSafeArea != oldWidget.padBottomSafeArea ||
        handle != oldWidget.handle;
  }
}

class _ClampedSpringSimulation extends Simulation {
  _ClampedSpringSimulation({
    required SpringDescription spring,
    required double start,
    required double end,
    required double velocity,
  }) : _end = end,
       _increasing = end >= start,
       _inner = SpringSimulation(spring, start, end, velocity);

  final SpringSimulation _inner;
  final double _end;
  final bool _increasing;

  @override
  double x(double time) {
    final double value = _inner.x(time);
    return _increasing ? math.min(value, _end) : math.max(value, _end);
  }

  @override
  double dx(double time) => isDone(time) ? 0 : _inner.dx(time);

  @override
  bool isDone(double time) {
    if (_inner.isDone(time)) return true;
    final double value = _inner.x(time);
    return _increasing ? value >= _end : value <= _end;
  }
}
