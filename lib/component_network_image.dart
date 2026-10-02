import 'package:flutter_components/component_skeleton.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentNetworkImage extends StatelessWidget {
  const ComponentNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = borderRadius ?? AppDecoration.borderRadiusLg;
    return ClipRSuperellipse(
      borderRadius: radius,
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return ComponentSkeleton(width: width ?? double.infinity, height: height ?? 160);
        },
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(child: Icon(Icons.broken_image_outlined)),
          );
        },
      ),
    );
  }
}
