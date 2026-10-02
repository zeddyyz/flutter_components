import 'package:flutter/widgets.dart';
import 'package:flutter_components/components_context_extension.dart';

class ComponentWeightedIcon extends StatelessWidget {
  const ComponentWeightedIcon({
    super.key,
    required this.icon,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
  });

  final IconData icon;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      String.fromCharCode(icon.codePoint),
      textAlign: .center,
      style: TextStyle(
        inherit: false,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        fontWeight: fontWeight ?? FontWeight.w700,
        fontSize: fontSize ?? 24,
        color: foregroundColor ?? (context.primary.withValues(alpha: 0.8)),
      ),
    );
  }
}
