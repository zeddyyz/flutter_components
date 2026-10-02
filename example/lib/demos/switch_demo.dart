import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class SwitchDemoPage extends StatefulWidget {
  const SwitchDemoPage({super.key});

  @override
  State<SwitchDemoPage> createState() => _SwitchDemoPageState();
}

class _SwitchDemoPageState extends State<SwitchDemoPage> {
  bool _isOn = true;
  bool _isOff = false;
  bool _hasCustomColor = true;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Switch',
      children: [
        DemoSection(
          title: 'On',
          child: ComponentSwitch(
            key: const ValueKey<String>('switch-on'),
            value: _isOn,
            onChanged: (bool value) => setState(() => _isOn = value),
          ),
        ),
        DemoSection(
          title: 'Off',
          child: ComponentSwitch(
            key: const ValueKey<String>('switch-off'),
            value: _isOff,
            onChanged: (bool value) => setState(() => _isOff = value),
          ),
        ),
        DemoSection(
          title: 'Disabled',
          child: const ComponentSwitch(
            key: ValueKey<String>('switch-disabled'),
            value: true,
            onChanged: null,
          ),
        ),
        DemoSection(
          title: 'Custom active color',
          child: ComponentSwitch(
            value: _hasCustomColor,
            onChanged: (bool value) => setState(() => _hasCustomColor = value),
            activeColor: Colors.green,
          ),
        ),
      ],
    );
  }
}
