import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class ProgressDemoPage extends StatefulWidget {
  const ProgressDemoPage({super.key});

  @override
  State<ProgressDemoPage> createState() => _ProgressDemoPageState();
}

class _ProgressDemoPageState extends State<ProgressDemoPage> {
  static const List<double> _presets = <double>[0, 0.25, 0.5, 0.75, 1];

  double _value = 0.5;

  @override
  Widget build(BuildContext context) {
    final String percentLabel = '${(_value * 100).round()}%';

    return DemoScaffold(
      title: 'Progress',
      children: [
        DemoSection(
          title: 'Bar',
          child: ComponentProgressBar(value: _value),
        ),
        DemoSection(
          title: 'Ring',
          child: ComponentProgressRing(
            value: _value,
            child: Text(percentLabel, style: context.caption2.semibold),
          ),
        ),
        DemoSection(
          title: 'Value',
          description: 'Tap a value to animate the bar and ring.',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final double preset in _presets)
                ComponentPill(
                  text: '${(preset * 100).round()}%',
                  onTap: () => setState(() => _value = preset),
                ),
            ],
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
