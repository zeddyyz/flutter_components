import 'package:flutter/material.dart';

/// Shows an alert snackbar with a message and an icon.
class AlertSnackbar {
  static Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>> show({
    required BuildContext context,
    required Widget icon,
    bool isError = false,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    bool isLightMode = Theme.of(context).brightness == Brightness.light;

    final snackbar = SnackBar(
      content: Column(
        children: [
          icon,
          SizedBox(width: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
      duration: duration,
      backgroundColor: isLightMode ? Colors.white : const Color.fromARGB(255, 18, 18, 18),
    );

    return ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static Future<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>> showPill({
    required BuildContext context,
    required Widget icon,
    bool isError = false,
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool center = false,
  }) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    bool isLightMode = Theme.of(context).brightness == Brightness.light;

    final snackbar = SnackBar(
      content: Row(
        mainAxisAlignment: center ? .center : .start,
        spacing: 12,
        children: [
          icon,
          Flexible(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: isLightMode ? Colors.black : Colors.white),
              textAlign: center ? .center : .start,
            ),
          ),
        ],
      ),
      duration: duration,
      backgroundColor: isLightMode ? const Color.fromRGBO(18, 18, 18, 1.0) : Colors.grey.shade200,
      behavior: SnackBarBehavior.floating,
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: isError
              ? Colors.red.withValues(alpha: 0.3)
              : Colors.blueAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      // width: context.adaptiveSize(240),
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.only(
        left: 16 + (center ? 8 : 0),
        right: 16,
        top: 16,
        bottom: 16,
      ),
      elevation: 0,
    );

    return ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
