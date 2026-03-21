import 'package:flutter/material.dart';

class SlideDownBar extends StatelessWidget {
  const SlideDownBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Container(
      height: 3,
      width: 50,
      decoration: BoxDecoration(
        color: isLightMode
            ? Colors.black.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
