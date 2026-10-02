import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class ControlsDemoPage extends StatefulWidget {
  const ControlsDemoPage({super.key});

  @override
  State<ControlsDemoPage> createState() => _ControlsDemoPageState();
}

class _ControlsDemoPageState extends State<ControlsDemoPage> {
  int _quantity = 2;
  double _volume = 0.4;
  int? _expanded = 0;
  String _city = 'Toronto';

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Controls',
      children: [
        DemoSection(
          title: 'Quantity stepper',
          child: ComponentQuantityStepper(
            value: _quantity,
            onChanged: (int value) => setState(() => _quantity = value),
          ),
        ),
        DemoSection(
          title: 'Slider',
          child: ComponentSlider(
            value: _volume,
            onChanged: (double value) => setState(() => _volume = value),
          ),
        ),
        DemoSection(
          title: 'Select field',
          child: ComponentSelectField<String>(
            hintText: 'City',
            value: _city,
            options: const [
              ComponentSelectOption(value: 'Toronto', label: 'Toronto'),
              ComponentSelectOption(value: 'Vancouver', label: 'Vancouver'),
              ComponentSelectOption(value: 'Montreal', label: 'Montreal'),
            ],
            onChanged: (String value) => setState(() => _city = value),
          ),
        ),
        DemoSection(
          title: 'Accordion',
          child: ComponentAccordion(
            expandedIndex: _expanded,
            onExpandedIndexChanged: (int? index) => setState(() => _expanded = index),
            items: const [
              ComponentAccordionItem(
                title: 'Shipping',
                child: Text('Arrives in 2–4 business days.'),
              ),
              ComponentAccordionItem(
                title: 'Returns',
                child: Text('Free returns within 30 days.'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Tooltip',
          child: const ComponentTooltip(
            message: 'More information',
            child: Icon(Icons.info_outline_rounded),
          ),
        ),
      ],
    );
  }
}
