import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logging_utility.dart';

/// A widget that waits for a [GetXController] to be registered in GetX and
/// rebuilds when the controller updates its state.
///
/// While the controller is not registered, it displays a [SizedBox].
/// Once the controller is registered, it calls the [builder] with the controller instance
/// and rebuilds whenever the controller state changes.
///
/// Example usage:
/// ```
/// GetxControllerRegistrationListener<MyController>(
///   builder: (controller) => MyView(controller: controller),
/// )
/// ```
class GetxControllerRegistrationListener<T extends GetxController> extends StatefulWidget {
  /// The widget builder that receives the registered controller.
  final Widget Function(T controller) builder;

  /// The widget to display while the controller is not registered.
  final Widget? loadingWidget;

  /// The polling interval to check for controller registration.
  final Duration pollingInterval;

  /// The maximum time to wait for registration before giving up.
  final Duration timeout;

  /// The tag of the controller to listen to.
  final String? tag;

  /// Whether to automatically rebuild when the controller updates.
  final bool isAutoReactive;

  /// The function to call when the controller is initialized.
  final VoidCallback? initState;

  /// Creates a [GetxControllerRegistrationListener].
  const GetxControllerRegistrationListener({
    required this.builder,
    this.loadingWidget,
    this.pollingInterval = const Duration(milliseconds: 100),
    this.timeout = const Duration(seconds: 10),
    this.tag,
    this.isAutoReactive = false,
    this.initState,
    super.key,
  });

  @override
  State<GetxControllerRegistrationListener<T>> createState() =>
      _ControllerRegistrationListenerState<T>();
}

class _ControllerRegistrationListenerState<T extends GetxController>
    extends State<GetxControllerRegistrationListener<T>> {
  /// Future that resolves when the controller is registered
  late Future<T> _controllerFuture;
  bool _isDisposed = false;
  bool _hasExecutedInitCallback = false;

  @override
  void initState() {
    super.initState();
    _controllerFuture = _waitForControllerRegistration();
    _controllerFuture.then((_) {
      if (!mounted || _hasExecutedInitCallback) {
        return;
      }
      _hasExecutedInitCallback = true;
      widget.initState?.call();
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Polls for controller registration and returns the controller when registered.
  Future<T> _waitForControllerRegistration() async {
    if (Get.isRegistered<T>(tag: widget.tag)) {
      return Get.find<T>(tag: widget.tag);
    }
    final Stopwatch stopwatch = Stopwatch()..start();
    while (!Get.isRegistered<T>(tag: widget.tag)) {
      if (_isDisposed || !mounted) {
        // throw StateError(
        //   'ControllerRegistrationListener<$T> was disposed before controller registration.',
        // );
        Logging.e(
          'GetxControllerRegistrationListener<$T> was disposed before controller registration.',
        );
      }
      await Future.delayed(widget.pollingInterval);
      if (_isDisposed || !mounted) {
        // throw StateError(
        //   'ControllerRegistrationListener<$T> was disposed before controller registration.',
        // );
        Logging.e(
          'GetxControllerRegistrationListener<$T> was disposed before controller registration.',
        );
      }
      if (stopwatch.elapsed > widget.timeout) {
        // throw TimeoutException(
        //   'Controller of type $T was not registered within ${widget.timeout}.',
        // );
        Logging.e('GetxController of type $T was not registered within ${widget.timeout}.');
      }
    }
    return Get.find<T>(tag: widget.tag);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _controllerFuture,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget ?? const SizedBox.shrink();
        }

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          if (!widget.isAutoReactive) {
            // Use GetBuilder to rebuild whenever controller updates
            return GetBuilder<T>(
              tag: widget.tag,
              builder: (T controller) => widget.builder(controller),
            );
          } else {
            return GetX<T>(
              tag: widget.tag,
              builder: (T controller) => widget.builder(controller),
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
  }
}
