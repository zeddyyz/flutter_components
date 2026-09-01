import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_components/flutter_components.dart';

/// A [ComponentSliverBlurredAppBar] with an iOS-style large title.
///
/// While the header is expanded the title is rendered large and aligned to the
/// bottom start of the header, optionally over a [subtitle]. As the scroll view
/// collapses the header, the large title fades out and the compact toolbar
/// title fades in, ending as a regular (centered by default) app bar title.
///
/// Place it as the first sliver of a [CustomScrollView]:
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     ComponentSliverLargeTitleAppBar(
///       context: context,
///       title: 'Summary',
///       expandedTrailing: const CircleAvatar(child: Text('AS')),
///     ),
///   ],
/// )
/// ```
class ComponentSliverLargeTitleAppBar extends StatelessWidget {
  const ComponentSliverLargeTitleAppBar({
    super.key,
    required this.context,
    required this.title,
    this.subtitle,
    this.largeTitleStyle,
    this.collapsedTitleStyle,
    this.subtitleStyle,
    this.subtitleMaxLines = 3,
    this.subtitleSpacing = 4,
    this.expandedTrailing,
    this.largeTitlePadding,
    this.leading,
    this.actions,
    this.centerCollapsedTitle = true,
    this.automaticallyImplyLeading = true,
    this.onBackButtonTap,
    this.expandedHeight,
    this.toolbarHeight,
    this.backgroundColor,
    this.foregroundColor,
    this.backgroundOpacity = 0.6,
    this.sigmaX = 12,
    this.sigmaY = 12,
    this.systemOverlayStyle,
    this.bottom,
    this.borderRadius,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.stretch = false,
    this.xAxisOverflowExtent,
  });

  final BuildContext context;

  /// The text shown both as the large title and as the collapsed toolbar title
  final String title;

  /// Optional supporting line shown under the large title. It fades out with
  /// the large title and is never shown in the collapsed toolbar
  final String? subtitle;

  /// Style of the title while the header is expanded
  final TextStyle? largeTitleStyle;

  /// Style of the title once the header is collapsed
  final TextStyle? collapsedTitleStyle;

  /// Style of the [subtitle]
  final TextStyle? subtitleStyle;

  /// How many lines the [subtitle] may wrap to before it is ellipsized
  final int subtitleMaxLines;

  /// Vertical gap between the large title and the [subtitle]
  final double subtitleSpacing;

  /// Optional widget shown at the end of the large title row, e.g. an avatar.
  /// It fades out together with the large title
  final Widget? expandedTrailing;

  /// Padding around the large title row
  final EdgeInsetsGeometry? largeTitlePadding;

  /// The leading widget, defaults to ModernBackButton if automaticallyImplyLeading is true
  final Widget? leading;

  /// List of action widgets to display at the end of the app bar
  final List<Widget>? actions;

  /// Whether the collapsed title is centered in the toolbar
  final bool centerCollapsedTitle;

  /// Whether to automatically add a leading widget
  final bool automaticallyImplyLeading;

  /// Custom callback for back button tap
  final VoidCallback? onBackButtonTap;

  /// The size of the app bar when it is fully expanded, defaults to a height
  /// that fits the toolbar plus the measured large title and [subtitle]. Set it
  /// explicitly when [expandedTrailing] is taller than a line of the title
  final double? expandedHeight;

  /// Height of the toolbar
  final double? toolbarHeight;

  /// Background color of the app bar, defaults to scaffold background with blur
  final Color? backgroundColor;

  /// Foreground color for the titles and icons
  final Color? foregroundColor;

  /// Opacity of the background color
  final double backgroundOpacity;

  /// Horizontal blur intensity
  final double sigmaX;

  /// Vertical blur intensity
  final double sigmaY;

  /// System overlay style for status bar
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// The bottom widget to display at the bottom of the app bar
  final PreferredSizeWidget? bottom;

  /// The border radius of the app bar shape
  final BorderRadius? borderRadius;

  /// Whether the app bar should remain visible at the start of the scroll view
  final bool pinned;

  /// Whether the app bar should become visible as soon as the user scrolls towards the app bar
  final bool floating;

  /// Whether the app bar should snap into view
  final bool snap;

  /// Whether the app bar should stretch to fill the over-scroll area
  final bool stretch;

  /// The overflow extent of the app bar on the x-axis, in situations where the blurr seems padded on the left and right sides
  final double? xAxisOverflowExtent;

  @override
  Widget build(BuildContext context) {
    var resolvedLargeTitleStyle =
        largeTitleStyle ?? context.displayBold.copyWith(height: 1.15, letterSpacing: 0);
    var resolvedCollapsedTitleStyle = collapsedTitleStyle ?? context.body2Heavy;

    if (foregroundColor != null) {
      resolvedLargeTitleStyle = resolvedLargeTitleStyle.copyWith(color: foregroundColor);
      resolvedCollapsedTitleStyle = resolvedCollapsedTitleStyle.copyWith(color: foregroundColor);
    }

    final resolvedSubtitleStyle =
        subtitleStyle ?? context.bodyMedium.copyWith(color: context.hintIntense);

    final resolvedToolbarHeight = toolbarHeight ?? kToolbarHeight;
    final resolvedLargeTitlePadding =
        largeTitlePadding ??
        EdgeInsetsDirectional.only(
          top: 20,
          start: context.defaultPadding,
          end: context.defaultPadding,
          bottom: 12,
        );

    // The expanded header has to be tall enough for the text it holds, so the
    // lines are measured at the width they will be laid out with, honouring the
    // user's text scale.
    final availableWidth = math.max(
      0.0,
      MediaQuery.sizeOf(context).width - resolvedLargeTitlePadding.horizontal,
    );
    var largeTitleHeight = _measureTextHeight(
      context,
      text: title,
      style: resolvedLargeTitleStyle,
      maxWidth: availableWidth,
      maxLines: 1,
    );
    if (subtitle != null) {
      largeTitleHeight +=
          subtitleSpacing +
          _measureTextHeight(
            context,
            text: subtitle!,
            style: resolvedSubtitleStyle,
            maxWidth: availableWidth,
            maxLines: subtitleMaxLines,
          );
    }

    return ComponentSliverBlurredAppBar(
      context: context,
      title: _CollapsedTitle(title: title, style: resolvedCollapsedTitleStyle),
      centerTitle: centerCollapsedTitle,
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      onBackButtonTap: onBackButtonTap,
      toolbarHeight: resolvedToolbarHeight,
      expandedHeight:
          expandedHeight ??
          resolvedToolbarHeight +
              largeTitleHeight +
              resolvedLargeTitlePadding.vertical +
              (bottom?.preferredSize.height ?? 0),
      flexibleSpace: _LargeTitle(
        title: title,
        style: resolvedLargeTitleStyle,
        subtitle: subtitle,
        subtitleStyle: resolvedSubtitleStyle,
        subtitleMaxLines: subtitleMaxLines,
        subtitleSpacing: subtitleSpacing,
        padding: resolvedLargeTitlePadding,
        trailing: expandedTrailing,
        bottomHeight: bottom?.preferredSize.height ?? 0,
      ),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      backgroundOpacity: backgroundOpacity,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      systemOverlayStyle: systemOverlayStyle,
      bottom: bottom,
      borderRadius: borderRadius,
      pinned: pinned,
      floating: floating,
      snap: snap,
      stretch: stretch,
      xAxisOverflowExtent: xAxisOverflowExtent,
    );
  }
}

/// The compact title, faded in over the last part of the collapse so it only
/// appears once the large title has cleared the toolbar.
class _CollapsedTitle extends StatelessWidget {
  const _CollapsedTitle({required this.title, required this.style});

  final String title;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return _CollapseBuilder(
      builder: (context, collapse) {
        return Opacity(
          opacity: Curves.easeIn.transform(_rangeProgress(collapse, 0.65, 1)),
          child: Text(title, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
        );
      },
    );
  }
}

/// The large title, pinned to the bottom of the flexible space so it rides up
/// with the header and fades out before it would overlap the toolbar.
class _LargeTitle extends StatelessWidget {
  const _LargeTitle({
    required this.title,
    required this.style,
    required this.subtitle,
    required this.subtitleStyle,
    required this.subtitleMaxLines,
    required this.subtitleSpacing,
    required this.padding,
    required this.bottomHeight,
    this.trailing,
  });

  final String title;
  final TextStyle style;
  final String? subtitle;
  final TextStyle subtitleStyle;
  final int subtitleMaxLines;
  final double subtitleSpacing;
  final EdgeInsetsGeometry padding;
  final double bottomHeight;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return _CollapseBuilder(
      builder: (context, collapse) {
        final opacity = 1 - Curves.easeOut.transform(_rangeProgress(collapse, 0.25, 0.8));
        if (opacity <= 0) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.only(bottom: bottomHeight),
          child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Opacity(
              opacity: opacity,
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          // The toolbar title already announces the screen name.
                          child: ExcludeSemantics(
                            child: Text(
                              title,
                              style: style,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        ?trailing,
                      ],
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: subtitleSpacing),
                      Text(
                        subtitle!,
                        style: subtitleStyle,
                        maxLines: subtitleMaxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Rebuilds with how far the enclosing [SliverAppBar] has collapsed, where 0 is
/// fully expanded and 1 is fully collapsed.
class _CollapseBuilder extends StatelessWidget {
  const _CollapseBuilder({required this.builder});

  final Widget Function(BuildContext context, double collapse) builder;

  @override
  Widget build(BuildContext context) {
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    if (settings == null) return builder(context, 0);

    final deltaExtent = settings.maxExtent - settings.minExtent;
    final collapse = deltaExtent <= 0
        ? 1.0
        : (1 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0);

    return builder(context, collapse);
  }
}

double _rangeProgress(double value, double start, double end) =>
    ((value - start) / (end - start)).clamp(0.0, 1.0);

double _measureTextHeight(
  BuildContext context, {
  required String text,
  required TextStyle style,
  required double maxWidth,
  required int maxLines,
}) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: maxLines,
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
  )..layout(maxWidth: maxWidth);

  final height = painter.height;
  painter.dispose();
  return height;
}
