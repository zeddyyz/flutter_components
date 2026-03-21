import 'package:flutter/material.dart';

Future<T?> showComponentFullScreenWidget<T>({
  required BuildContext context,
  required Widget child,
}) async {
  return await showGeneralDialog<T>(
    context: context,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(animation),
        child: child,
      );
    },
    pageBuilder: (context, animation1, animation2) => child,
  );
}
