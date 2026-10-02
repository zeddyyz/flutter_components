import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/component_activity_indicator.dart';
import 'package:material_ui/material_ui.dart';

class ActivityIndicatorDemoPage extends StatelessWidget {
  const ActivityIndicatorDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Activity indicator',
      children: [
        const DemoSection(
          title: 'Default',
          description: '22px, theme primary color.',
          child: ComponentActivityIndicator(
            key: ValueKey<String>('activity-indicator'),
          ),
        ),
        const DemoSection(
          title: 'Large',
          description: '44px with a matching stroke.',
          child: ComponentActivityIndicator(
            key: ValueKey<String>('activity-indicator-large'),
            size: 44,
            strokeWidth: 3.6,
          ),
        ),
        const DemoSection(
          title: 'Colored',
          description: 'Explicit color override.',
          child: ComponentActivityIndicator(
            key: ValueKey<String>('activity-indicator-colored'),
            color: Color(0xFF2F80ED),
          ),
        ),
      ],
    );
  }
}
