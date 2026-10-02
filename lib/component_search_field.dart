import 'dart:async';

import 'package:flutter_components/component_theme.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentSearchField extends StatefulWidget {
  const ComponentSearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.onSubmitted,
    this.debounce = Duration.zero,
    this.showCancelButton = false,
    this.onCancel,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// When greater than [Duration.zero], [onChanged] fires after typing pauses.
  final Duration debounce;
  final bool showCancelButton;
  final VoidCallback? onCancel;
  final bool autofocus;

  @override
  State<ComponentSearchField> createState() => _ComponentSearchFieldState();
}

class _ComponentSearchFieldState extends State<ComponentSearchField> {
  static const ValueKey<String> _clearKey = ValueKey<String>('search-field-clear');
  static const ValueKey<String> _cancelKey = ValueKey<String>('search-field-cancel');

  late bool _isClearVisible;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _isClearVisible = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onControllerTextChanged);
  }

  @override
  void didUpdateWidget(covariant ComponentSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerTextChanged);
      widget.controller.addListener(_onControllerTextChanged);
      final bool shouldShow = widget.controller.text.isNotEmpty;
      if (shouldShow != _isClearVisible) {
        _isClearVisible = shouldShow;
      }
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    widget.controller.removeListener(_onControllerTextChanged);
    super.dispose();
  }

  void _onControllerTextChanged() {
    final bool shouldShow = widget.controller.text.isNotEmpty;
    if (shouldShow == _isClearVisible) return;
    setState(() {
      _isClearVisible = shouldShow;
    });
  }

  void _emitChanged(String value) {
    final ValueChanged<String>? onChanged = widget.onChanged;
    if (onChanged == null) return;
    onChanged(value);
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    if (widget.onChanged == null) return;
    if (widget.debounce <= Duration.zero) {
      _emitChanged(value);
      return;
    }
    _debounceTimer = Timer(widget.debounce, () {
      _debounceTimer = null;
      if (!mounted) return;
      _emitChanged(value);
    });
  }

  void _flushPendingDebounce(String value) {
    if (_debounceTimer == null) return;
    _debounceTimer!.cancel();
    _debounceTimer = null;
    _emitChanged(value);
  }

  void _onSubmitted(String value) {
    _flushPendingDebounce(value);
    widget.onSubmitted?.call(value);
  }

  void _clear() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    widget.controller.clear();
    _emitChanged('');
  }

  void _cancel() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    widget.controller.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    _emitChanged('');
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    final ComponentThemeData theme = context.componentTheme;
    final TextStyle style = context.textTheme.bodyMedium ?? const TextStyle(fontSize: 16);
    final TextStyle hintStyle = style.copyWith(color: theme.hintColor);

    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: theme.chipColor,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppDecoration.borderRadiusStadium,
                side: BorderSide(color: theme.borderColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 22,
                    color: theme.hintColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      autofocus: widget.autofocus,
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      style: style,
                      cursorColor: context.primary,
                      onChanged: _onChanged,
                      onSubmitted: _onSubmitted,
                      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecoration.collapsed(
                        hintText: widget.hintText,
                        hintStyle: hintStyle,
                      ),
                    ),
                  ),
                  if (_isClearVisible) ...[
                    const SizedBox(width: 8),
                    ComponentGestureClick(
                      key: _clearKey,
                      semanticsLabel: 'Clear text',
                      onTap: _clear,
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (widget.showCancelButton) ...[
          const SizedBox(width: 8),
          ComponentGestureClick(
            key: _cancelKey,
            semanticsLabel: 'Cancel',
            onTap: _cancel,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Text(
                'Cancel',
                style: context.body2Medium,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
