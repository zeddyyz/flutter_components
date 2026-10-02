import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class ProgressDemoPage extends StatelessWidget {
  const ProgressDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Progress',
      children: [
        const DemoSection(
          title: 'Bar',
          child: ComponentProgressBar(value: 0.62),
        ),
        DemoSection(
          title: 'Ring',
          child: ComponentProgressRing(
            value: 0.72,
            child: Text('72%', style: context.labelHeavy),
          ),
        ),
        const DemoSection(
          title: 'Page indicator',
          child: ComponentPageIndicator(count: 4, index: 1),
        ),
      ],
    );
  }
}
