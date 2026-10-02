import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/component_segmented_control.dart';
import 'package:material_ui/material_ui.dart';

class SegmentedControlDemoPage extends StatefulWidget {
  const SegmentedControlDemoPage({super.key});

  @override
  State<SegmentedControlDemoPage> createState() => _SegmentedControlDemoPageState();
}

class _SegmentedControlDemoPageState extends State<SegmentedControlDemoPage> {
  String _layout = 'list';
  String _range = 'day';

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Segmented control',
      children: [
        DemoSection(
          title: 'Two segments',
          description: 'Equal-width segments with an optional icon.',
          child: ComponentSegmentedControl<String>(
            segments: const [
              ComponentSegment<String>(
                value: 'list',
                label: 'List',
                icon: Icon(Icons.view_list_rounded),
              ),
              ComponentSegment<String>(
                value: 'grid',
                label: 'Grid',
                icon: Icon(Icons.grid_view_rounded),
              ),
            ],
            value: _layout,
            onChanged: (String value) => setState(() => _layout = value),
          ),
        ),
        DemoSection(
          title: 'Three segments',
          description: 'Sliding thumb stays within the full parent width.',
          child: ComponentSegmentedControl<String>(
            segments: const [
              ComponentSegment<String>(value: 'day', label: 'Day'),
              ComponentSegment<String>(value: 'week', label: 'Week'),
              ComponentSegment<String>(value: 'month', label: 'Month'),
            ],
            value: _range,
            onChanged: (String value) => setState(() => _range = value),
          ),
        ),
      ],
    );
  }
}
