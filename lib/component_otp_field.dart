import 'package:flutter/services.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentOtpField extends StatefulWidget {
  const ComponentOtpField({
    super.key,
    required this.length,
    required this.onCompleted,
    this.onChanged,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  @override
  State<ComponentOtpField> createState() => _ComponentOtpFieldState();
}

class _ComponentOtpFieldState extends State<ComponentOtpField> {
  late final List<TextEditingController> _controllers = List<TextEditingController>.generate(
    widget.length,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _nodes = List<FocusNode>.generate(widget.length, (_) => FocusNode());

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    for (final FocusNode node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((controller) => controller.text).join();

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      _distributePaste(value);
      return;
    }
    if (value.isNotEmpty && index < widget.length - 1) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    widget.onChanged?.call(_code);
    if (_code.length == widget.length && !_code.contains('')) {
      widget.onCompleted(_code);
    }
  }

  void _distributePaste(String value) {
    final String digits = value.replaceAll(RegExp(r'\D'), '');
    for (int i = 0; i < widget.length; i++) {
      _controllers[i].text = i < digits.length ? digits[i] : '';
    }
    widget.onChanged?.call(_code);
    if (digits.length >= widget.length) {
      _nodes.last.requestFocus();
      widget.onCompleted(_code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < widget.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: TextField(
              key: ValueKey<String>('otp-$i'),
              controller: _controllers[i],
              focusNode: _nodes[i],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: context.body3Heavy,
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: context.componentTheme.cardColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppDecoration.borderRadiusLg,
                  borderSide: BorderSide(color: context.componentTheme.borderColorIntense),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppDecoration.borderRadiusLg,
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              onChanged: (String value) => _onChanged(i, value),
            ),
          ),
        ],
      ],
    );
  }
}
