import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_components/component_dialog_widget.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

/// To initialize AlertSnackbar - add to MaterialApp builder
///  builder: (context, child) => Overlay(
//   initialEntries: [
//     OverlayEntry(
//       builder: (context) {
//         AlertSnackbar.init(context);
//         return child!;
//       },
//     ),
//   ],
// ),

/// A stacking, self-reflowing toast system styled after an iOS island banner.
///
/// The first toast anchors just below the status bar. Subsequent toasts stagger
/// *downward* with [_kStackGap] between them (newest on top). Up to
/// [_kMaxVisible] toasts are shown at once; any extras wait in a FIFO queue and
/// are promoted into a slot as visible toasts dismiss. Survivors ease to their
/// new [AnimatedPositioned] slot instead of jumping.
///
/// Drag a toast down to ~40% of the screen height and it morphs into a
/// [ComponentDialogWidget]. Ok dismisses the dialog and the toast together.
class AlertSnackbar {
  AlertSnackbar._();

  static late BuildContext _context;
  static void init(BuildContext context) => _context = context;

  /// Max number of toasts rendered on screen simultaneously.
  static const int _kMaxVisible = 3;

  /// Vertical gap between stacked toasts.
  static const double _kStackGap = 8.0;

  /// Horizontal inset on compact screens.
  static const double _kCompactInset = 16.0;

  /// Max width of the capsule on wide layouts.
  static const double _kMaxWidth = 420.0;

  /// Pull-down distance, as a fraction of screen height, that locks the dialog.
  static const double _kExpandThresholdFraction = 0.4;

  /// Height of the expanded [ComponentDialogWidget] (one confirm button).
  static const double _kDialogHeight = 240;

  /// Reactive list of currently visible toasts (index 0 = oldest).
  static final ValueNotifier<List<_ToastData>> _visible = ValueNotifier<List<_ToastData>>(
    <_ToastData>[],
  );

  /// FIFO queue of toasts waiting for a free slot.
  static final Queue<_ToastData> _pending = Queue<_ToastData>();

  /// The single persistent overlay entry hosting the whole stack.
  static OverlayEntry? _entry;

  /// Dimmer behind banners while a toast is being pulled. Visual only — it
  /// never competes for the drag the toast already owns.
  static final ValueNotifier<double> _scrim = ValueNotifier<double>(0);

  static void _syncStackScrim() {
    double maxScrim = 0;
    for (final _ToastData toast in _visible.value) {
      if (toast.expanded) continue;
      if (toast.scrim > maxScrim) maxScrim = toast.scrim;
    }
    if ((_scrim.value - maxScrim).abs() > 0.004) {
      _scrim.value = maxScrim;
    } else if (maxScrim <= 0 && _scrim.value != 0) {
      _scrim.value = 0;
    }
  }

  /// Adds a toast to the stack (or the pending queue if the stack is full).
  static void show({
    bool isError = false,
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 5),
  }) {
    _ensureEntry();

    final _ToastData toast = _ToastData(
      isError: isError,
      title: title,
      message: message,
      duration: duration,
    );

    if (_visible.value.length < _kMaxVisible) {
      _promote(toast);
    } else {
      _pending.add(toast);
    }
  }

  static void _notify() {
    _visible.value = List<_ToastData>.of(_visible.value);
  }

  /// Moves [toast] into the visible stack and schedules its auto-dismiss.
  static void _promote(_ToastData toast) {
    _visible.value = <_ToastData>[..._visible.value, toast];
    _scheduleAutoDismiss(toast);
  }

  static void _scheduleAutoDismiss(_ToastData toast) {
    toast.dismissTimer?.cancel();
    toast.dismissTimer = Timer(toast.duration, () {
      if (toast.expanded || toast.pullingDown) return;
      final VoidCallback? runExit = toast.runExitAnimation;
      if (runExit != null) {
        runExit();
      } else {
        _dismiss(toast);
      }
    });
  }

  /// Collapses [toast]'s layout slot so neighbors can ease into place while
  /// the pill itself is still playing its exit transform.
  static void _collapseSlot(_ToastData toast) {
    if (toast.exiting) return;
    toast.exiting = true;
    toast.height = 0;
    _notify();
  }

  static void _reportHeight(_ToastData toast, double height) {
    if (toast.exiting || toast.pullingDown || toast.expanded) return;
    if ((toast.height - height).abs() < 0.5) return;
    toast.height = height;
    _notify();
  }

  static void _beginPull(_ToastData toast) {
    if (toast.pullingDown) return;
    toast.pullingDown = true;
    toast.dismissTimer?.cancel();
    toast.dismissTimer = null;
  }

  static void _endPull(_ToastData toast) {
    toast.pullingDown = false;
    toast.expanded = false;
    if (!toast.exiting) toast.height = 72;
    _notify();
    _scheduleAutoDismiss(toast);
  }

  static void _lockExpanded(_ToastData toast) {
    toast.pullingDown = true;
    toast.expanded = true;
    toast.height = 0;
    toast.scrim = 0;
    _syncStackScrim();
    toast.dismissTimer?.cancel();
    toast.dismissTimer = null;
    _notify();
  }

  /// Removes [toast] from the visible stack, reflows survivors, and pulls the
  /// next pending toast (if any) into the freed slot.
  static void _dismiss(_ToastData toast) {
    toast.dismissTimer?.cancel();
    if (!_visible.value.contains(toast)) return;

    _visible.value = _visible.value.where((_ToastData t) => t != toast).toList();

    if (_pending.isNotEmpty && _visible.value.length < _kMaxVisible) {
      _promote(_pending.removeFirst());
    }

    if (_visible.value.isEmpty && _pending.isEmpty) _removeEntry();
  }

  /// Lazily inserts the persistent overlay entry once.
  static void _ensureEntry() {
    if (_entry != null && _entry!.mounted) return;
    _entry = OverlayEntry(
      builder: (BuildContext overlayContext) => _ToastStack(context: overlayContext),
    );
    Overlay.of(_context).insert(_entry!);
  }

  static void _removeEntry() {
    if (_entry?.mounted ?? false) _entry!.remove();
    _entry = null;
  }

  /// Cancels timers and drops the overlay. Widget tests must call this in
  /// `tearDown` because the stack is process-wide static state.
  @visibleForTesting
  static void debugReset() {
    for (final _ToastData toast in _visible.value) {
      toast.dismissTimer?.cancel();
    }
    for (final _ToastData toast in _pending) {
      toast.dismissTimer?.cancel();
    }
    _visible.value = <_ToastData>[];
    _pending.clear();
    _scrim.value = 0;
    _removeEntry();
  }
}

/// Data for a single toast in the stack.
class _ToastData {
  _ToastData({
    required this.isError,
    required this.title,
    required this.message,
    required this.duration,
  });

  final bool isError;
  final String? title;
  final String message;
  final Duration duration;
  final GlobalKey<_ToastPillState> pillKey = GlobalKey<_ToastPillState>();
  Timer? dismissTimer;

  /// Layout height used to stack neighbors. Estimated until measured; `0` while exiting.
  double height = 72;

  /// True once the pill has started its exit animation; slot height is then 0.
  bool exiting = false;

  /// True while the user is pulling the banner down toward the dialog.
  bool pullingDown = false;

  /// True after the pull crosses the expand threshold and the dialog is locked.
  bool expanded = false;

  /// 0–1 pull dimmer for this toast. Stack takes the max of non-expanded toasts.
  double scrim = 0;

  /// Bound by the mounted pill so timers/taps can play the same exit motion.
  VoidCallback? runExitAnimation;
}

/// Colors for one toast. Dark matches the iOS low-battery island; light is the
/// same geometry inverted so the capsule stays readable on pale scaffolds.
class _ToastPalette {
  const _ToastPalette({
    required this.background,
    required this.title,
    required this.accent,
    required this.border,
    required this.shadows,
  });

  final Color background;
  final Color title;
  final Color accent;
  final Color border;
  final List<BoxShadow> shadows;

  /// Gold sampled from the iOS low-battery live activity.
  static const Color _goldDark = Color(0xFFE4C56A);
  static const Color _goldLight = Color(0xFFC4A032);
  static const Color _mintDark = Color(0xFF8FCB9A);
  static const Color _mintLight = Color(0xFF2F7D4F);

  factory _ToastPalette.of(BuildContext context, {required bool isError}) {
    final bool isDark = context.isDarkMode;
    final Color accent = isError
        ? (isDark ? _goldDark : _goldLight)
        : (isDark ? _mintDark : _mintLight);

    if (isDark) {
      return _ToastPalette(
        background: const Color(0xFF1C1C1E),
        title: const Color(0xFFFFFFFF),
        accent: accent,
        border: const Color.fromARGB(255, 46, 45, 45),
        shadows: const <BoxShadow>[
          BoxShadow(
            color: Color(0x88000000),
            blurRadius: 24,
            offset: Offset(0, 10),
            spreadRadius: -4,
          ),
        ],
      );
    }

    return _ToastPalette(
      background: const Color(0xFFFFFFFF),
      title: const Color(0xFF1C1C1E),
      accent: accent,
      border: const Color(0x1F000000),
      shadows: const <BoxShadow>[
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 28,
          offset: Offset(0, 12),
          spreadRadius: -6,
        ),
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}

/// Renders the full stack of toasts, easing them with [AnimatedPositioned]
/// whenever [AlertSnackbar._visible] changes.
class _ToastStack extends StatelessWidget {
  const _ToastStack({required this.context});

  final BuildContext context;

  static const Cubic _kReflowCurve = Cubic(0.16, 1.0, 0.32, 1.0);
  static const Duration _kReflowDuration = Duration(milliseconds: 420);

  @override
  Widget build(BuildContext _) {
    return ValueListenableBuilder<List<_ToastData>>(
      valueListenable: AlertSnackbar._visible,
      builder: (BuildContext ctx, List<_ToastData> toasts, _) {
        final double width = MediaQuery.sizeOf(context).width;
        final bool compact = context.isMobile || width < 600;
        final double side = compact
            ? AlertSnackbar._kCompactInset
            : math.max(
                24.0,
                (width - AlertSnackbar._kMaxWidth) / 2,
              );
        final double topOrigin = MediaQuery.viewPaddingOf(context).top + (compact ? 6.0 : 16.0);

        final Map<_ToastData, double> tops = <_ToastData, double>{};
        double runningTop = topOrigin;
        for (final _ToastData toast in toasts.reversed) {
          tops[toast] = runningTop;
          if (!toast.exiting && !toast.pullingDown && !toast.expanded && toast.height > 0) {
            runningTop += toast.height + AlertSnackbar._kStackGap;
          }
        }

        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            ValueListenableBuilder<double>(
              valueListenable: AlertSnackbar._scrim,
              builder: (BuildContext context, double t, _) {
                return Positioned.fill(
                  child: IgnorePointer(
                    child: ColoredBox(
                      color: Color.fromRGBO(0, 0, 0, 0.45 * t.clamp(0.0, 1.0)),
                    ),
                  ),
                );
              },
            ),
            for (final _ToastData toast in toasts)
              AnimatedPositioned(
                key: ObjectKey(toast),
                duration: toast.expanded ? Duration.zero : _kReflowDuration,
                curve: _kReflowCurve,
                left: toast.expanded ? 0 : side,
                right: toast.expanded ? 0 : side,
                top: toast.expanded ? 0 : tops[toast]!,
                bottom: toast.expanded ? 0 : null,
                child: _ToastPill(
                  key: toast.pillKey,
                  data: toast,
                  overlayContext: context,
                  restTop: tops[toast]!,
                  side: side,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// A single island-style toast. Swipe up to dismiss, drag down to expand into
/// a [ComponentDialogWidget].
class _ToastPill extends StatefulWidget {
  const _ToastPill({
    super.key,
    required this.data,
    required this.overlayContext,
    required this.restTop,
    required this.side,
  });

  final _ToastData data;
  final BuildContext overlayContext;
  final double restTop;
  final double side;

  @override
  State<_ToastPill> createState() => _ToastPillState();
}

class _ToastPillState extends State<_ToastPill> with TickerProviderStateMixin {
  static const Cubic _kMotionCurve = Cubic(0.16, 1.0, 0.32, 1.0);
  static const Duration _kEnterDuration = Duration(milliseconds: 420);
  static const Duration _kExitDuration = Duration(milliseconds: 280);
  static const Duration _kSettleDuration = Duration(milliseconds: 320);
  static const Duration _kExpandDuration = Duration(milliseconds: 420);
  static const double _kDismissDistance = 40;
  static const double _kDismissVelocity = 800;
  static const double _kExpandVelocity = 900;

  late final AnimationController _enter;
  late final AnimationController _drag;
  late final AnimationController _exit;
  late final AnimationController _expand;
  late final CurvedAnimation _enterCurve;
  late final Listenable _motion;

  bool _exiting = false;
  bool _locked = false;
  double _anchorTop = 0;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(vsync: this, duration: _kEnterDuration)..forward();
    _drag = AnimationController.unbounded(vsync: this);
    _exit = AnimationController(vsync: this, duration: _kExitDuration);
    _expand = AnimationController(vsync: this, duration: _kExpandDuration);
    _enterCurve = CurvedAnimation(parent: _enter, curve: _kMotionCurve);
    _motion = Listenable.merge(<Listenable>[_enter, _drag, _exit, _expand]);
    _drag.addListener(_publishScrim);
    _expand.addListener(_publishScrim);
    widget.data.runExitAnimation = _playExit;
    _anchorTop = widget.restTop;
  }

  @override
  void didUpdateWidget(covariant _ToastPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      oldWidget.data.runExitAnimation = null;
      widget.data.runExitAnimation = _playExit;
    }
    if (!widget.data.pullingDown && !widget.data.expanded) {
      _anchorTop = widget.restTop;
    }
  }

  @override
  void dispose() {
    if (widget.data.runExitAnimation == _playExit) {
      widget.data.runExitAnimation = null;
    }
    widget.data.scrim = 0;
    AlertSnackbar._syncStackScrim();
    _drag.removeListener(_publishScrim);
    _expand.removeListener(_publishScrim);
    _enterCurve.dispose();
    _enter.dispose();
    _drag.dispose();
    _exit.dispose();
    _expand.dispose();
    super.dispose();
  }

  /// Lock when the banner itself sits ~40% down the screen, not after dragging
  /// a full 40% of screen height from the status-bar rest position.
  double get _threshold {
    final double lockY =
        MediaQuery.sizeOf(widget.overlayContext).height * AlertSnackbar._kExpandThresholdFraction;
    return math.max(72.0, lockY - _anchorTop);
  }

  void _publishScrim() {
    final double t = widget.data.expanded ? 0 : math.max(_pullProgress, _expand.value);
    if ((widget.data.scrim - t).abs() < 0.004) return;
    widget.data.scrim = t;
    AlertSnackbar._syncStackScrim();
  }

  double get _pullProgress {
    if (_drag.value <= 0) return 0;
    return (_drag.value / _threshold).clamp(0.0, 1.0);
  }

  void _playExit() {
    if (_exiting) return;
    _exiting = true;
    _locked = false;
    AlertSnackbar._collapseSlot(widget.data);
    _exit.forward().whenComplete(() {
      AlertSnackbar._dismiss(widget.data);
    });
  }

  void _lockExpanded() {
    if (_locked || _exiting) return;
    _locked = true;
    HapticFeedback.mediumImpact();
    AlertSnackbar._lockExpanded(widget.data);
    _publishScrim();
    _expand.forward();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_exiting || _locked) return;
    final double next = _drag.value + details.delta.dy;
    if (next > 0 && !widget.data.pullingDown) {
      _anchorTop = widget.restTop;
      AlertSnackbar._beginPull(widget.data);
    }
    _drag.value = next;
    if (_drag.value >= _threshold) {
      _drag.value = _threshold;
      _lockExpanded();
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_exiting || _locked) return;
    final double velocity = details.velocity.pixelsPerSecond.dy;
    if (_drag.value <= -_kDismissDistance || velocity <= -_kDismissVelocity) {
      _playExit();
      return;
    }
    if (_drag.value >= _threshold ||
        (_drag.value > _threshold * 0.2 && velocity >= _kExpandVelocity)) {
      _lockExpanded();
      return;
    }
    _settleBackToRest();
  }

  void _onVerticalDragCancel() {
    if (_exiting || _locked) return;
    _settleBackToRest();
  }

  void _settleBackToRest() {
    _drag.animateTo(0, duration: _kSettleDuration, curve: _kMotionCurve).whenComplete(() {
      if (!mounted || _locked) return;
      if (widget.data.pullingDown) AlertSnackbar._endPull(widget.data);
    });
  }

  String get _headline {
    final String? rawTitle = widget.data.title?.trim();
    if (rawTitle != null && rawTitle.isNotEmpty) return rawTitle;
    return widget.data.message;
  }

  String? get _subtitle {
    final String? rawTitle = widget.data.title?.trim();
    if (rawTitle != null && rawTitle.isNotEmpty) return widget.data.message;
    return null;
  }

  Widget _buildDialog() {
    return ComponentDialogWidget(
      height: AlertSnackbar._kDialogHeight,
      title: _headline,
      description: _subtitle,
      confirmText: 'Ok',
      cancelText: '',
      showCancel: false,
      isDestructive: widget.data.isError,
      onConfirm: _playExit,
      onCancel: () {},
    );
  }

  Widget _buildPill(_ToastPalette palette) {
    final String headline = _headline;
    final String? subtitle = _subtitle;

    return _MeasureSize(
      onChange: (Size size) => AlertSnackbar._reportHeight(widget.data, size.height),
      child: RepaintBoundary(
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: palette.background,
            shadows: palette.shadows,
            shape: RoundedSuperellipseBorder(
              borderRadius: AppDecoration.borderRadiusStadium,
              side: BorderSide(color: palette.border, width: 1.0),
            ),
          ),
          child: ClipRSuperellipse(
            borderRadius: AppDecoration.borderRadiusStadium,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 20, 16),
              child: Row(
                crossAxisAlignment: .center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .start,
                      children: <Widget>[
                        Text(
                          headline,
                          softWrap: true,
                          style: widget.overlayContext.textTheme.bodyMedium?.copyWith(
                            color: palette.title,
                            height: 1.2,
                            letterSpacing: -0.25,
                          ),
                          textAlign: subtitle != null ? TextAlign.start : TextAlign.center,
                        ),
                        if (subtitle != null) ...<Widget>[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            softWrap: true,
                            style: widget.overlayContext.textTheme.bodyMedium?.copyWith(
                              color: palette.accent,
                              height: 1.25,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: ShapeDecoration(
                        color: palette.accent.withValues(alpha: 0.2),
                        shape: RoundedSuperellipseBorder(
                          borderRadius: AppDecoration.borderRadiusStadium,
                        ),
                      ),
                      child: Icon(
                        widget.data.isError ? Icons.priority_high_rounded : Icons.done_rounded,
                        color: palette.accent,
                        size: 24,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext _) {
    final _ToastPalette palette = _ToastPalette.of(
      widget.overlayContext,
      isError: widget.data.isError,
    );
    final bool filling = widget.data.expanded || _expand.value > 0;

    return AnimatedBuilder(
      animation: _motion,
      builder: (BuildContext context, Widget? child) {
        final double enterT = _enterCurve.value;
        final double pull = _pullProgress;
        final double expandT = _expand.value;
        final double scrim = math.max(pull, expandT);

        if (!filling) {
          final double y = ((1 - enterT) * -28) + _drag.value + (_exit.value * -64);
          final double scale = 0.97 + (0.03 * enterT) + (0.04 * pull);
          final double dragFade = (_drag.value >= 0)
              ? 1.0
              : (1 - (_drag.value.abs() / 160)).clamp(0.6, 1.0);
          final double opacity = (enterT * (1 - _exit.value) * dragFade).clamp(0.0, 1.0);

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, y),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: child,
              ),
            ),
          );
        }

        final Size screen = MediaQuery.sizeOf(widget.overlayContext);
        final double dialogTop = (screen.height - AlertSnackbar._kDialogHeight) / 2;
        final double fingerTop = _anchorTop + math.max(0.0, _drag.value);
        final double top = lerpDouble(fingerTop, dialogTop, expandT)!;
        final double side = lerpDouble(widget.side, 24, expandT)!;

        final double exitFade = 1 - _exit.value;

        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              child: IgnorePointer(
                ignoring: expandT < 0.95 || _exiting,
                child: ModalBarrier(
                  dismissible: false,
                  color: Color.fromRGBO(0, 0, 0, 0.45 * scrim * exitFade),
                ),
              ),
            ),
            Positioned(
              top: top,
              left: side,
              right: side,
              child: Opacity(
                opacity: ((1 - expandT) * exitFade).clamp(0.0, 1.0),
                child: IgnorePointer(
                  ignoring: expandT > 0.2,
                  child: Transform.scale(
                    scale: 1 + (0.04 * pull),
                    alignment: Alignment.topCenter,
                    child: child,
                  ),
                ),
              ),
            ),
            if (expandT > 0)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: expandT < 0.5 || _exiting,
                  child: Opacity(
                    opacity: expandT * exitFade,
                    child: _buildDialog(),
                  ),
                ),
              ),
          ],
        );
      },
      child: GestureDetector(
        key: ValueKey<String>('alert-snackbar-banner-${identityHashCode(widget.data)}'),
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_locked || _exiting || _drag.value.abs() > 8) return;
          _playExit();
        },
        onPanUpdate: _onVerticalDragUpdate,
        onPanEnd: _onVerticalDragEnd,
        onPanCancel: _onVerticalDragCancel,
        child: _buildPill(palette),
      ),
    );
  }
}

/// Reports the child's layout size after each frame it changes.
class _MeasureSize extends StatefulWidget {
  const _MeasureSize({
    required this.onChange,
    required this.child,
  });

  final ValueChanged<Size> onChange;
  final Widget child;

  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  Size? _last;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _notify());
  }

  void _notify() {
    if (!mounted) return;
    final RenderObject? object = context.findRenderObject();
    if (object is! RenderBox || !object.hasSize) return;
    final Size size = object.size;
    if (_last == size) return;
    _last = size;
    widget.onChange(size);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _notify());
        return true;
      },
      child: SizeChangedLayoutNotifier(child: widget.child),
    );
  }
}
