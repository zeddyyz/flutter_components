import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_components/flutter_components.dart';

@MultiBrightnessPreview()
Widget componentTextFieldPreview() {
  return ComponentTextField(
    controller: TextEditingController(),
    hintText: "Enter something...",
    icon: Icon(Icons.search),
    isError: false,
  );
}

final class MultiBrightnessPreview extends MultiPreview {
  const MultiBrightnessPreview();

  @override
  List<Preview> get previews => const [
    Preview(
      group: 'Brightness',
      name: 'Example - light',
      brightness: Brightness.light,
    ),
    Preview(
      group: 'Brightness',
      name: 'Example - dark',
      brightness: Brightness.dark,
    ),
  ];
}

class ComponentTextField extends StatelessWidget {
  const ComponentTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.maxLines = 1,
    this.prefixText,
    this.isFilled = false,
    this.inputFormatters,
    this.backgroundColor,
    this.isError = false,
    this.borderRadius,
  });

  final TextEditingController controller;
  final String hintText;
  final Widget icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final int maxLines;
  final String? prefixText;
  final bool isFilled;
  final List<TextInputFormatter>? inputFormatters;
  final Color? backgroundColor;
  final bool isError;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = context.primary;
    final Color fillColor = backgroundColor ?? context.cardColor;
    final TextStyle style = context.theme.textTheme.bodyLarge ?? const TextStyle(fontSize: 16);

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      style: style,
      cursorColor: primaryColor,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: style.copyWith(
          color: primaryColor.withValues(alpha: 0.4),
        ),
        prefixText: prefixText,
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        filled: isFilled,
        fillColor: fillColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.6),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        prefixIcon: Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: primaryColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          margin: const EdgeInsets.only(right: 16),
          child: icon,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 80),
      ),
    );
  }
}
