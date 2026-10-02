import 'package:flutter_components/components_context_extension.dart';
import 'package:material_ui/material_ui.dart';

/// Centered empty-state copy on compact screens. On tablets and desktop the
/// content stays start-aligned in a ~480pt box so the window is not wasted on
/// a narrow centered column.
class ComponentEmptyState extends StatelessWidget {
  const ComponentEmptyState({
    super.key,
    this.icon,
    required this.title,
    this.message,
    this.action,
  }) : _isError = false;

  const ComponentEmptyState.error({
    super.key,
    this.icon,
    required this.title,
    this.message,
    this.action,
  }) : _isError = true;

  final Widget? icon;
  final String title;
  final String? message;
  final Widget? action;
  final bool _isError;

  static const double _kLargeMaxWidth = 480;

  @override
  Widget build(BuildContext context) {
    final bool isCompact = context.isMobile;
    final Color iconColor = _isError
        ? context.componentTheme.dangerColor
        : context.componentTheme.hintColor;
    final TextAlign textAlign = isCompact ? TextAlign.center : TextAlign.start;
    final TextStyle titleStyle = isCompact ? context.headlineHeavy : context.body3Heavy;

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isCompact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          IconTheme.merge(
            data: IconThemeData(size: 64, color: iconColor),
            child: icon!,
          ),
          const SizedBox(height: 16),
        ],
        Text(
          title,
          textAlign: textAlign,
          style: titleStyle,
        ),
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            textAlign: textAlign,
            style: context.bodyMedium.copyWith(color: context.componentTheme.hintColor),
          ),
        ],
        if (action != null) ...[
          const SizedBox(height: 24),
          KeyedSubtree(
            key: const ValueKey<String>('empty-state-action'),
            child: action!,
          ),
        ],
      ],
    );

    if (isCompact) {
      return Center(
        key: const ValueKey<String>('empty-state'),
        child: content,
      );
    }

    return Align(
      key: const ValueKey<String>('empty-state'),
      alignment: AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _kLargeMaxWidth),
        child: content,
      ),
    );
  }
}
