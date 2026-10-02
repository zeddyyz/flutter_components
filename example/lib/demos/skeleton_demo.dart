import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/component_skeleton.dart';
import 'package:material_ui/material_ui.dart';

class SkeletonDemoPage extends StatelessWidget {
  const SkeletonDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Skeleton',
      children: [
        const DemoSection(
          title: 'Circle',
          description: 'Avatar-style placeholder.',
          child: ComponentSkeleton.circle(diameter: 64),
        ),
        const DemoSection(
          title: 'Text lines',
          description: 'Soft stadium bones for copy.',
          child: Column(
            spacing: 10,
            children: [
              ComponentSkeleton.text(height: 16),
              ComponentSkeleton.text(width: 220, height: 14),
              ComponentSkeleton.text(width: 160, height: 14),
            ],
          ),
        ),
        const DemoSection(
          title: 'Block',
          description: 'Rounded superellipse placeholder.',
          child: ComponentSkeleton(width: double.infinity, height: 120),
        ),
        const DemoSection(
          title: 'List tiles',
          description: 'Circle plus two text lines, one shared shimmer.',
          child: ComponentSkeletonList(itemCount: 5),
        ),
      ],
    );
  }
}
