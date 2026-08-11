import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// What should happen to the modal once an app bar action has finished its work.
///
/// Returned by a [ComponentModalActionHandler] so the widget inside the modal
/// stays in charge of the decision: validation that fails returns [stay], a
/// successful submit returns [ComponentModalAction.close] with the value
/// `ComponentResponsiveModal.show` should complete with.
class ComponentModalAction {
  const ComponentModalAction._stay() : closesModal = false, result = null;

  /// Keeps the modal open, for example because validation failed.
  static const ComponentModalAction stay = ComponentModalAction._stay();

  /// Closes the modal, completing `ComponentResponsiveModal.show` with [result].
  const ComponentModalAction.close([this.result]) : closesModal = true;

  /// Whether the modal should be popped.
  final bool closesModal;

  /// The value the modal completes with when [closesModal] is `true`.
  final Object? result;
}

/// The work an app bar action runs, owned by the widget inside the modal.
///
/// It may be synchronous or asynchronous; while an asynchronous handler runs the
/// controller reports [ComponentModalController.isBusy] and refuses further
/// invocations.
typedef ComponentModalActionHandler = FutureOr<ComponentModalAction> Function();

/// Bridges the app bar actions of `ComponentResponsiveModal.show` with the
/// widget shown in the modal's body.
///
/// The app bar and the body are siblings under the modal's `Scaffold`, so an
/// action widget built at the call site cannot reach the body's state. The modal
/// creates this controller, hands it to its `actionsBuilder`, and publishes it
/// through a [ComponentModalScope]; the widget in the body claims the action
/// with [attach], which keeps validation and submit logic inside that widget.
///
/// The body claims the action from its `build`, so the action's enabled state
/// always matches the widget's current state:
///
/// ```dart
/// class _EditProfileFormState extends State<EditProfileForm> {
///   @override
///   Widget build(BuildContext context) {
///     ComponentModalScope.of(context).attach(onInvoke: _save, isEnabled: _name.text.isNotEmpty);
///     return Form(key: _formKey, child: ...);
///   }
///
///   Future<ComponentModalAction> _save() async {
///     if (!_formKey.currentState!.validate()) return ComponentModalAction.stay;
///     return ComponentModalAction.close(await _repository.save(_draft));
///   }
/// }
/// ```
///
/// Pass a method tear-off such as `_save` rather than an inline closure so
/// repeated [attach] calls can tell that nothing changed.
class ComponentModalController extends ChangeNotifier {
  ComponentModalController({required ValueSetter<Object?> onClose}) : _onClose = onClose;

  final ValueSetter<Object?> _onClose;

  ComponentModalActionHandler? _handler;
  bool _isEnabled = true;
  bool _isBusy = false;
  bool _isDisposed = false;

  /// Whether [invoke] currently runs anything.
  ///
  /// `false` until the body has claimed the action, while the body reports
  /// itself as invalid, and while a handler is still running.
  bool get isEnabled => _handler != null && _isEnabled && !_isBusy;

  /// Whether a handler is running, so actions can show a loading state.
  bool get isBusy => _isBusy;

  /// Whether the widget in the body has claimed the action.
  bool get hasHandler => _handler != null;

  /// Claims the modal's app bar action for [onInvoke].
  ///
  /// Safe to call from `build`: it only notifies listeners when [onInvoke] or
  /// [isEnabled] actually changed.
  void attach({required ComponentModalActionHandler onInvoke, bool isEnabled = true}) {
    if (_handler == onInvoke && _isEnabled == isEnabled) return;
    _handler = onInvoke;
    _isEnabled = isEnabled;
    _notify();
  }

  /// Gives up the action, leaving it disabled.
  ///
  /// Ignored when [onInvoke] is no longer the claimed handler, so a widget being
  /// replaced cannot detach its successor's handler.
  void detach(ComponentModalActionHandler onInvoke) {
    if (_handler != onInvoke) return;
    _handler = null;
    _notify();
  }

  /// Runs the claimed handler, then closes the modal if the handler asked for it.
  ///
  /// Wire this to the action widget's tap callback. Re-entrant taps are ignored
  /// while a handler is running.
  Future<void> invoke() async {
    final handler = _handler;
    if (handler == null || !isEnabled) return;

    _isBusy = true;
    _notify();

    final ComponentModalAction action;
    try {
      action = await handler();
    } finally {
      _isBusy = false;
      _notify();
    }

    if (action.closesModal) close(action.result);
  }

  /// Pops the modal, completing `ComponentResponsiveModal.show` with [result].
  void close([Object? result]) {
    if (_isDisposed) return;
    _onClose(result);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _notify() {
    if (_isDisposed) return;

    // [attach] is meant to be called while the body builds, and the app bar is a
    // sibling that may already have been built in this frame, so notifying
    // synchronously would mark an already-built widget dirty.
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks || phase == SchedulerPhase.midFrameMicrotasks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_isDisposed) return;
        notifyListeners();
      });
      return;
    }

    notifyListeners();
  }
}

/// Exposes the [ComponentModalController] of the enclosing modal to the widget
/// shown in the modal's body.
class ComponentModalScope extends InheritedWidget {
  const ComponentModalScope({super.key, required this.controller, required super.child});

  final ComponentModalController controller;

  /// The controller of the enclosing modal, or `null` when the widget is not
  /// inside a `ComponentResponsiveModal.show`.
  static ComponentModalController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ComponentModalScope>()?.controller;

  /// The controller of the enclosing modal.
  static ComponentModalController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(
      controller != null,
      'ComponentModalScope.of() was called with a context that is not inside a '
      'ComponentResponsiveModal.show(). Look the controller up from the state of '
      'the widget returned by the modal\'s builder, not from the builder context.',
    );
    return controller!;
  }

  @override
  bool updateShouldNotify(ComponentModalScope oldWidget) => controller != oldWidget.controller;
}
