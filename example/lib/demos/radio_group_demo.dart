import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class RadioGroupDemoPage extends StatefulWidget {
  const RadioGroupDemoPage({super.key});

  @override
  State<RadioGroupDemoPage> createState() => _RadioGroupDemoPageState();
}

class _RadioGroupDemoPageState extends State<RadioGroupDemoPage> {
  String _plan = 'pro';

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Radio group',
      children: [
        DemoSection(
          title: 'Plans',
          child: ComponentRadioGroup<String>(
            header: 'Choose a plan',
            value: _plan,
            onChanged: (String value) => setState(() => _plan = value),
            options: const [
              ComponentRadioOption(value: 'free', label: 'Free', subtitle: 'Personal use'),
              ComponentRadioOption(value: 'pro', label: 'Pro', subtitle: 'For small teams'),
              ComponentRadioOption(value: 'max', label: 'Max', subtitle: 'Unlimited seats'),
            ],
          ),
        ),
      ],
    );
  }
}
