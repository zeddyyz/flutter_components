import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class SelectionCardDemoPage extends StatefulWidget {
  const SelectionCardDemoPage({super.key});

  @override
  State<SelectionCardDemoPage> createState() => _SelectionCardDemoPageState();
}

class _SelectionCardDemoPageState extends State<SelectionCardDemoPage> {
  String _plan = 'pro';
  final Set<String> _features = {'analytics'};
  bool _notificationsOn = true;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Selection card',
      children: [
        DemoSection(
          title: 'Single select',
          description: 'One card stays selected, like a radio group.',
          child: ComponentSelectionGroup<String>(
            value: _plan,
            onChanged: (String value) => setState(() => _plan = value),
            options: const [
              ComponentSelectionOption(
                value: 'free',
                icon: Icon(Icons.person_outline_rounded),
                title: 'Free',
                subtitle: 'Personal use',
              ),
              ComponentSelectionOption(
                value: 'pro',
                icon: Icon(Icons.workspace_premium_outlined),
                title: 'Pro',
                subtitle: 'For small teams',
              ),
              ComponentSelectionOption(
                value: 'max',
                icon: Icon(Icons.apartment_outlined),
                title: 'Max',
                subtitle: 'Unlimited seats',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Multi select',
          description: 'Tap to add or remove, like a checkbox group.',
          child: ComponentSelectionGroup<String>.multi(
            values: _features,
            onValuesChanged: (Set<String> values) => setState(() {
              _features
                ..clear()
                ..addAll(values);
            }),
            options: const [
              ComponentSelectionOption(
                value: 'analytics',
                icon: Icon(Icons.insights_outlined),
                title: 'Analytics',
                subtitle: 'Weekly reports',
              ),
              ComponentSelectionOption(
                value: 'sharing',
                icon: Icon(Icons.ios_share_rounded),
                title: 'Sharing',
                subtitle: 'Invite collaborators',
              ),
              ComponentSelectionOption(
                value: 'offline',
                icon: Icon(Icons.cloud_off_outlined),
                title: 'Offline',
                subtitle: 'Keep a local copy',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'On / off',
          description: 'A single card can stand in for a switch.',
          child: ComponentSelectionCard(
            key: const ValueKey<String>('selection-notifications'),
            icon: const Icon(Icons.notifications_outlined),
            title: 'Notifications',
            subtitle: 'Badges, sounds, and banners',
            selected: _notificationsOn,
            onTap: () => setState(() => _notificationsOn = !_notificationsOn),
          ),
        ),
        DemoSection(
          title: 'Custom accent',
          child: ComponentSelectionCard(
            key: const ValueKey<String>('selection-accent'),
            icon: const Icon(Icons.eco_outlined),
            accent: Colors.green,
            title: 'Eco mode',
            subtitle: 'Lower energy use',
            selected: true,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
