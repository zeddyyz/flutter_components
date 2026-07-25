import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

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

/// A stacking, self-reflowing toast system.
///
/// The first toast anchors at the bottom padding. Subsequent toasts stagger
/// *upward* above it by [_kSlotSpacing] each (newest on top). Up to
/// [_kMaxVisible] toasts are shown at once; any extras wait in a FIFO queue and
/// are promoted into a slot as visible toasts dismiss. When a toast dismisses,
/// the survivors animate to fill the gap via [AnimatedPositioned].
class AlertSnackbar {
  AlertSnackbar._();

  static late BuildContext _context;
  static late Widget _animationWidget;
  static late Widget _icon;

  static void init(BuildContext context, Widget animationWidget, Widget icon) {
    _context = context;
    _animationWidget = animationWidget;
    _icon = icon;
  }

  /// Max number of toasts rendered on screen simultaneously.
  static const int _kMaxVisible = 3;

  /// Vertical gap between stacked toasts (measured slot-to-slot).
  static const double _kSlotSpacing = kIsWeb ? 68 : 60.0;

  /// Reactive list of currently visible toasts (index 0 = bottom-most).
  static final ValueNotifier<List<_ToastData>> _visible = ValueNotifier<List<_ToastData>>(
    <_ToastData>[],
  );

  /// FIFO queue of toasts waiting for a free slot.
  static final Queue<_ToastData> _pending = Queue<_ToastData>();

  /// The single persistent overlay entry hosting the whole stack.
  static OverlayEntry? _entry;

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
      animationWidget: _animationWidget,
      icon: _icon,
    );

    if (_visible.value.length < _kMaxVisible) {
      _promote(toast);
    } else {
      _pending.add(toast);
    }
  }

  /// Moves [toast] into the visible stack and schedules its auto-dismiss.
  static void _promote(_ToastData toast) {
    _visible.value = <_ToastData>[..._visible.value, toast];
    toast.dismissTimer = Timer(toast.duration, () => _dismiss(toast));
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
    if (_entry != null) return;
    final OverlayState overlay = Overlay.of(_context);
    _entry = OverlayEntry(builder: (_) => _ToastStack(context: _context));
    overlay.insert(_entry!);
  }

  static void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }
}

/// Immutable data for a single toast in the stack.
class _ToastData {
  _ToastData({
    required this.isError,
    required this.title,
    required this.message,
    required this.duration,
    required this.animationWidget,
    required this.icon,
  });

  final bool isError;
  final String? title;
  final String message;
  final Duration duration;
  final Key key = UniqueKey();
  Timer? dismissTimer;
  Widget animationWidget;
  Widget icon;
}

/// Renders the full stack of toasts, reflowing them with [AnimatedPositioned]
/// whenever [AlertComponent._visible] changes.
class _ToastStack extends StatelessWidget {
  const _ToastStack({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return ValueListenableBuilder<List<_ToastData>>(
      valueListenable: AlertSnackbar._visible,
      builder: (BuildContext ctx, List<_ToastData> toasts, _) {
        final double left = context.isMobile ? 55.0 : context.viewWidth * 0.38;
        final double right = context.isMobile ? 55.0 : context.viewWidth * 0.38;

        return Stack(
          children: <Widget>[
            for (int i = 0; i < toasts.length; i++)
              AnimatedPositioned(
                key: toasts[i].key,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: left,
                right: right,
                bottom: context.bottomPadding + (i * AlertSnackbar._kSlotSpacing),
                child: _ToastPill(
                  data: toasts[i],
                  context: context,
                  onDismiss: () => AlertSnackbar._dismiss(toasts[i]),
                  animationWidget: (child) => toasts[i].animationWidget,
                  icon: toasts[i].icon,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// A single toast pill. Keeps the original design; adds swipe-to-dismiss and a
/// fade-in on entry.
class _ToastPill extends StatelessWidget {
  const _ToastPill({
    required this.data,
    required this.context,
    required this.onDismiss,
    required this.animationWidget,
    required this.icon,
  });

  final _ToastData data;
  final BuildContext context;
  final VoidCallback onDismiss;
  final Widget Function(Widget child) animationWidget;
  final Widget icon;

  @override
  Widget build(BuildContext _) {
    return animationWidget(
      Dismissible(
        key: ValueKey<Key>(data.key),
        direction: DismissDirection.horizontal,
        onDismissed: (_) => onDismiss(),
        child: ClipRSuperellipse(
          borderRadius: AppDecoration.borderRadiusStadium,
          child: RepaintBoundary(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 12, top: 8, bottom: 8),
                decoration: ShapeDecoration(
                  color: context.bottomSheetCardColor.withValues(alpha: 0.5),
                  shape: RoundedSuperellipseBorder(
                    borderRadius: AppDecoration.borderRadiusStadium,
                    side: BorderSide(color: context.borderColor),
                  ),
                ),
                child: Row(
                  spacing: kIsWeb ? 12 : 8,
                  mainAxisSize: .min,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: data.isError ? Colors.red : Colors.blueAccent,
                      radius: 18,
                      child: icon,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: .min,
                        mainAxisAlignment: .center,
                        children: <Widget>[
                          if (data.title != null)
                            Text(
                              data.title!,
                              style: context.textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          Text(
                            data.message,
                            style: context.textTheme.labelSmall!.copyWith(
                              color: data.title != null ? context.hintIntense : context.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    if (kIsWeb && !context.isMobile)
                      IconButton(
                        onPressed: () => onDismiss(),
                        icon: Icon(
                          Icons.close,
                          color: context.primary,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: context.borderColor,
                          minimumSize: const Size(40, 40),
                          fixedSize: const Size(40, 40),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
