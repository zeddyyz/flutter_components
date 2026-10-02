import 'dart:ui';

import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

enum _IconButtonSurface { plain, filled, blurred }

/// Icon-only or icon + text.
///
/// Default is a ghost control. [ComponentIconButton.filled] adds a solid
/// background. [ComponentIconButton.blurred] is filled with a backdrop blur.
/// Pass [label] on any constructor for icon + text.
class ComponentIconButton extends StatelessWidget {
  const ComponentIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  }) : _surface = _IconButtonSurface.plain;

  const ComponentIconButton.filled({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  }) : _surface = _IconButtonSurface.filled;

  const ComponentIconButton.blurred({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  }) : _surface = _IconButtonSurface.blurred;

  final Widget icon;
  final Widget? label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback onPressed;
  final bool isLoading;

  final _IconButtonSurface _surface;

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor = foregroundColor ?? context.primary;
    final Widget iconChild = isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: indicatorColor,
            ),
          )
        : icon;

    final Widget button = label == null
        ? _buildIconButton(iconChild, context)
        : _buildLabeledButton(iconChild, context);

    if (_surface != _IconButtonSurface.blurred) {
      return button;
    }

    return _BlurredIconButton(child: button);
  }

  Color? _resolveBackgroundColor(BuildContext context) {
    if (backgroundColor != null) {
      return backgroundColor;
    }

    return switch (_surface) {
      _IconButtonSurface.plain => null,
      _IconButtonSurface.filled => context.iconButtonBackgroundColor,
      _IconButtonSurface.blurred => context.iconButtonBackgroundColor.withValues(alpha: 0.3),
    };
  }

  Color? _resolveForegroundColor(BuildContext context) {
    if (foregroundColor != null) {
      return foregroundColor;
    }

    return switch (_surface) {
      _IconButtonSurface.plain => null,
      _IconButtonSurface.filled || _IconButtonSurface.blurred => context.primary,
    };
  }

  IconButton _buildIconButton(Widget iconChild, BuildContext context) {
    final Color? resolvedBackgroundColor = _resolveBackgroundColor(context);
    final Color? resolvedForegroundColor = _resolveForegroundColor(context);

    return IconButton(
      onPressed: isLoading ? null : onPressed,
      icon: iconChild,
      style: IconButton.styleFrom(
        backgroundColor: resolvedBackgroundColor,
        foregroundColor: resolvedForegroundColor,
        disabledBackgroundColor: resolvedBackgroundColor,
        disabledForegroundColor: resolvedForegroundColor,
        shape: RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusStadium,
        ),
        elevation: 0,
        splashFactory: NoSplash.splashFactory,
        enabledMouseCursor: SystemMouseCursors.click,
        disabledMouseCursor: SystemMouseCursors.forbidden,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(40, 40),
        maximumSize: const Size(40, 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  TextButton _buildLabeledButton(Widget iconChild, BuildContext context) {
    final Color? resolvedBackgroundColor = _resolveBackgroundColor(context);
    final Color? resolvedForegroundColor = _resolveForegroundColor(context);

    return TextButton.icon(
      onPressed: isLoading ? null : onPressed,
      label: label!,
      icon: iconChild,
      style: TextButton.styleFrom(
        backgroundColor: resolvedBackgroundColor,
        foregroundColor: resolvedForegroundColor,
        disabledBackgroundColor: resolvedBackgroundColor,
        disabledForegroundColor: resolvedForegroundColor,
        shape: const RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusStadium,
        ),
        elevation: 0,
        splashFactory: NoSplash.splashFactory,
        enabledMouseCursor: SystemMouseCursors.click,
        disabledMouseCursor: SystemMouseCursors.forbidden,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(40, 40),
        padding: const EdgeInsets.only(
          left: 12,
          top: 10,
          bottom: 10,
          right: 18,
        ),
      ),
    );
  }
}

class _BlurredIconButton extends StatelessWidget {
  const _BlurredIconButton({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRSuperellipse(
      borderRadius: AppDecoration.borderRadiusStadium,
      child: RepaintBoundary(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
            tileMode: TileMode.clamp,
          ),
          child: child,
        ),
      ),
    );
  }
}
