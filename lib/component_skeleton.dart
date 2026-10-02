import 'package:flutter_components/component_theme.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

enum _SkeletonKind { rect, circle, text }

/// Soft superellipse shimmer placeholder.
///
/// Standalone bones own a 1.2s sliding gradient. Descendants of
/// [ComponentSkeletonList] share that list's single [AnimationController].
class ComponentSkeleton extends StatelessWidget {
  const ComponentSkeleton({
    super.key,
    this.width,
    this.height = 48,
    this.borderRadius,
  }) : _kind = _SkeletonKind.rect;

  const ComponentSkeleton.circle({
    super.key,
    double diameter = 40,
    this.borderRadius,
  }) : width = diameter,
       height = diameter,
       _kind = _SkeletonKind.circle;

  const ComponentSkeleton.text({
    super.key,
    this.width,
    this.height = 14,
    this.borderRadius,
  }) : _kind = _SkeletonKind.text;

  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final _SkeletonKind _kind;

  @override
  Widget build(BuildContext context) {
    final Widget bone = _ComponentSkeletonBone(
      width: width,
      height: height,
      borderRadius: borderRadius ?? _defaultBorderRadius(context),
    );
    if (_ComponentShimmerMarker.exists(context)) {
      return bone;
    }
    return _ComponentShimmer(child: bone);
  }

  BorderRadius _defaultBorderRadius(BuildContext context) {
    return switch (_kind) {
      _SkeletonKind.circle => BorderRadius.circular(height / 2),
      _SkeletonKind.text => AppDecoration.borderRadiusStadium,
      _SkeletonKind.rect => context.componentTheme.cardBorderRadius,
    };
  }
}

/// A few list-tile rows that share one shimmer [AnimationController].
class ComponentSkeletonList extends StatelessWidget {
  const ComponentSkeletonList({
    super.key,
    this.itemCount = 3,
    this.avatarDiameter = 44,
  });

  final int itemCount;
  final double avatarDiameter;

  @override
  Widget build(BuildContext context) {
    final Widget tiles = Column(
      spacing: 16,
      children: [
        for (int index = 0; index < itemCount; index++)
          Row(
            children: [
              ComponentSkeleton.circle(diameter: avatarDiameter),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    const ComponentSkeleton.text(height: 14),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.62,
                        child: ComponentSkeleton.text(height: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );

    if (_ComponentShimmerMarker.exists(context)) {
      return tiles;
    }
    return _ComponentShimmer(child: tiles);
  }
}

class _ComponentSkeletonBone extends StatelessWidget {
  const _ComponentSkeletonBone({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final Widget bone = SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: context.componentTheme.shimmerBackgroundColor,
          shape: RoundedSuperellipseBorder(borderRadius: borderRadius),
        ),
      ),
    );

    if (width == null) {
      return bone;
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: bone,
    );
  }
}

class _ComponentShimmer extends StatefulWidget {
  const _ComponentShimmer({required this.child});

  final Widget child;

  @override
  State<_ComponentShimmer> createState() => _ComponentShimmerState();
}

class _ComponentShimmerState extends State<_ComponentShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ComponentThemeData theme = context.componentTheme;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: <Color>[
                  theme.shimmerBaseColor,
                  theme.shimmerHighlightColor,
                  theme.shimmerBaseColor,
                ],
                stops: const <double>[0.25, 0.5, 0.75],
                begin: const Alignment(-1, -0.2),
                end: const Alignment(1, 0.2),
                tileMode: TileMode.clamp,
                transform: _SlidingGradientTransform(slidePercent: _controller.value),
              ).createShader(bounds);
            },
            child: child,
          );
        },
        child: _ComponentShimmerMarker(child: widget.child),
      ),
    );
  }
}

class _ComponentShimmerMarker extends InheritedWidget {
  const _ComponentShimmerMarker({required super.child});

  static bool exists(BuildContext context) {
    return context.getInheritedWidgetOfExactType<_ComponentShimmerMarker>() != null;
  }

  @override
  bool updateShouldNotify(_ComponentShimmerMarker oldWidget) => false;
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (slidePercent * 2.0 - 1.0), 0, 0);
  }
}
