import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class CheckboxDemoPage extends StatefulWidget {
  const CheckboxDemoPage({super.key});

  @override
  State<CheckboxDemoPage> createState() => _CheckboxDemoPageState();
}

class _CheckboxDemoPageState extends State<CheckboxDemoPage> {
  bool _accepted = true;
  bool _marketing = false;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Checkbox',
      children: [
        DemoSection(
          title: 'Labeled',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              ComponentCheckbox(
                key: const ValueKey<String>('checkbox-accepted'),
                value: _accepted,
                label: 'Accept terms',
                onChanged: (bool value) => setState(() => _accepted = value),
              ),
              ComponentCheckbox(
                key: const ValueKey<String>('checkbox-marketing'),
                value: _marketing,
                label: 'Send product updates',
                onChanged: (bool value) => setState(() => _marketing = value),
              ),
              const ComponentCheckbox(
                key: ValueKey<String>('checkbox-disabled'),
                value: true,
                label: 'Disabled',
                onChanged: null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
