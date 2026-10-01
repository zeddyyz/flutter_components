import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_components/component_no_splash_theme.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentTextField extends StatefulWidget {
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
    this.inputFormatters,
    this.backgroundColor,
    this.borderColor,
    this.isError = false,
    this.isEnabled = true,
    this.borderRadius,
    this.showSimple = false,
    this.groupId = EditableText,
    this.initialValue,
    this.focusNode,
    this.forceErrorText,
    this.decoration,
    this.style,
    this.showClearTextButton = false,
    this.onClearText,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.toolbarOptions,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.onTapUpOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.errorBuilder,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.cursorErrorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.selectAllOnFocus,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.undoController,
    this.onAppPrivateCommand,
    this.cursorOpacityAnimates,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.contentInsertionConfiguration,
    this.statesController,
    this.clipBehavior = Clip.hardEdge,
    this.scribbleEnabled = true,
    this.stylusHandwritingEnabled = EditableText.defaultStylusHandwritingEnabled,
    this.canRequestFocus = true,
    this.hintLocales,
  });

  final TextEditingController controller;
  final String hintText;
  final Widget icon;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool isError;
  final BorderRadius? borderRadius;
  final bool showSimple;
  final bool isEnabled;
  final bool showClearTextButton;
  final VoidCallback? onClearText;

  /// All parameters of [TextFormField]
  final Object groupId;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? forceErrorText;
  final InputDecoration? decoration;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  // ignore: deprecated_member_use
  final ToolbarOptions? toolbarOptions;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final bool onTapAlwaysCalled;
  final TapRegionCallback? onTapOutside;
  final TapRegionUpCallback? onTapUpOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldErrorBuilder? errorBuilder;
  final bool? enabled;
  final bool? ignorePointers;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Color? cursorErrorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final bool? selectAllOnFocus;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final UndoHistoryController? undoController;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final bool? cursorOpacityAnimates;
  final ui.BoxHeightStyle? selectionHeightStyle;
  final ui.BoxWidthStyle? selectionWidthStyle;
  final DragStartBehavior dragStartBehavior;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final WidgetStatesController? statesController;
  final Clip clipBehavior;
  final bool scribbleEnabled;
  final bool stylusHandwritingEnabled;
  final bool canRequestFocus;
  final List<Locale>? hintLocales;

  @override
  State<ComponentTextField> createState() => _ComponentTextFieldState();
}

class _ComponentTextFieldState extends State<ComponentTextField> {
  bool _isClearTextButtonVisible = false;

  double getHeight() {
    if (widget.maxLines == null) return 56.0;
    return switch (widget.maxLines) {
      1 => 56.0,
      2 => 76.0,
      3 => 94.0,
      4 => 114.0,
      _ => 56.0,
    };
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (widget.controller.text.isEmpty) {
      setState(() {
        _isClearTextButtonVisible = false;
      });
    } else {
      setState(() {
        _isClearTextButtonVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color fillColor = widget.backgroundColor ?? Colors.transparent;
    final Color effectiveBorderColor = widget.isError
        ? Colors.red
        : widget.borderColor ??
              (fillColor == Colors.transparent
                  ? (context.isLightMode ? context.borderColorIntense : context.borderColor)
                  : (widget.backgroundColor ?? Colors.transparent));
    final TextStyle effectiveStyle =
        widget.style ?? context.textTheme.bodyMedium ?? const TextStyle(fontSize: 16);

    return Container(
      height: getHeight(),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      decoration: ShapeDecoration(
        color: fillColor,
        shape: RoundedSuperellipseBorder(
          borderRadius: widget.borderRadius ?? AppDecoration.borderRadiusCard,
          side: BorderSide(
            color: effectiveBorderColor,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: widget.maxLines == 1 ? .center : .start,
        children: [
          if (!widget.showSimple) ...[
            widget.icon,
            SizedBox(width: 16),
            VerticalDivider(
              color: context.isLightMode ? context.borderColorIntense : context.borderColor,
            ),
            SizedBox(width: 16),
          ],
          Expanded(
            child: _buildTextField(context, effectiveStyle),
          ),
          AnimatedOpacity(
            opacity: _isClearTextButtonVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: ComponentNoSplashTheme(
                child: ComponentGestureClick(
                  onTap: widget.onClearText ?? () => widget.controller.clear(),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, TextStyle effectiveStyle) {
    return TextFormField(
      groupId: widget.groupId,
      controller: widget.controller,
      initialValue: widget.initialValue,
      focusNode: widget.focusNode,
      forceErrorText: widget.forceErrorText,
      // decoration: decoration ?? _decoration(primaryColor, fillColor, effectiveStyle),
      decoration: InputDecoration.collapsed(
        hintText: widget.hintText,
        hintStyle: effectiveStyle,
        enabled: widget.isEnabled,
      ),
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      style: effectiveStyle,
      strutStyle: widget.strutStyle,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      // ignore: deprecated_member_use
      toolbarOptions: widget.toolbarOptions,
      showCursor: widget.showCursor,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onTapAlwaysCalled: widget.onTapAlwaysCalled,
      onTapOutside: widget.onTapOutside ?? (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onTapUpOutside: widget.onTapUpOutside,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      validator: widget.validator,
      errorBuilder: widget.errorBuilder,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      ignorePointers: widget.ignorePointers,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor ?? context.primary,
      cursorErrorColor: widget.cursorErrorColor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectAllOnFocus: widget.selectAllOnFocus,
      selectionControls: widget.selectionControls,
      buildCounter: widget.buildCounter,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      autovalidateMode: widget.autovalidateMode,
      scrollController: widget.scrollController,
      restorationId: widget.restorationId,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      mouseCursor: widget.mouseCursor,
      contextMenuBuilder: widget.contextMenuBuilder,
      spellCheckConfiguration: widget.spellCheckConfiguration,
      magnifierConfiguration: widget.magnifierConfiguration,
      undoController: widget.undoController,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      cursorOpacityAnimates: widget.cursorOpacityAnimates,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      dragStartBehavior: widget.dragStartBehavior,
      contentInsertionConfiguration: widget.contentInsertionConfiguration,
      statesController: widget.statesController,
      clipBehavior: widget.clipBehavior,
      // ignore: deprecated_member_use
      scribbleEnabled: widget.scribbleEnabled,
      stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
      canRequestFocus: widget.canRequestFocus,
      hintLocales: widget.hintLocales,
    );
  }
}

Widget _defaultContextMenuBuilder(BuildContext context, EditableTextState editableTextState) {
  if (SystemContextMenu.isSupportedByField(editableTextState)) {
    return SystemContextMenu.editableText(editableTextState: editableTextState);
  }
  return AdaptiveTextSelectionToolbar.editableText(editableTextState: editableTextState);
}
