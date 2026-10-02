import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class ListSectionDemoPage extends StatefulWidget {
  const ListSectionDemoPage({super.key});

  @override
  State<ListSectionDemoPage> createState() => _ListSectionDemoPageState();
}

class _ListSectionDemoPageState extends State<ListSectionDemoPage> {
  bool _wifiOn = true;
  bool _marketingOn = false;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'List section',
      children: [
        Text(
          'Pass backgroundColor: Colors.transparent on ComponentListTile when '
          'placing tiles inside a ComponentListSection so they share one card.',
          style: context.bodyMedium.copyWith(color: context.hintIntense),
        ),
        ComponentListSection(
          children: [
            ComponentListTile(
              key: const ValueKey<String>('section-wifi'),
              backgroundColor: Colors.transparent,
              leading: Icon(Icons.wifi_rounded, color: context.primary),
              title: const Text('Wi-Fi'),
              trailing: Icon(Icons.chevron_right_rounded, color: context.hint),
              onTap: () => AlertSnackbar.show(message: 'Wi-Fi'),
            ),
            ComponentListTile(
              key: const ValueKey<String>('section-bluetooth'),
              backgroundColor: Colors.transparent,
              leading: Icon(Icons.bluetooth_rounded, color: context.primary),
              title: const Text('Bluetooth'),
              trailing: Icon(Icons.chevron_right_rounded, color: context.hint),
              onTap: () => AlertSnackbar.show(message: 'Bluetooth'),
            ),
            ComponentListTile(
              key: const ValueKey<String>('section-notifications'),
              backgroundColor: Colors.transparent,
              leading: Icon(Icons.notifications_outlined, color: context.primary),
              title: const Text('Notifications'),
              trailing: Icon(Icons.chevron_right_rounded, color: context.hint),
              onTap: () => AlertSnackbar.show(message: 'Notifications'),
            ),
          ],
        ),
        ComponentListSection(
          header: 'Settings rows',
          footer: 'Use switch and checkbox tiles for compact on/off rows.',
          children: [
            ComponentListTile.switchTile(
              key: const ValueKey<String>('section-switch-wifi'),
              backgroundColor: Colors.transparent,
              leading: Icon(Icons.wifi_rounded, color: context.primary),
              title: const Text('Wi-Fi'),
              value: _wifiOn,
              onChanged: (bool value) => setState(() => _wifiOn = value),
            ),
            ComponentListTile.checkboxTile(
              key: const ValueKey<String>('section-checkbox-marketing'),
              backgroundColor: Colors.transparent,
              leading: Icon(Icons.campaign_outlined, color: context.primary),
              title: const Text('Marketing emails'),
              value: _marketingOn,
              onChanged: (bool value) => setState(() => _marketingOn = value),
            ),
          ],
        ),
        ComponentListSection(
          header: 'About',
          footer: 'Version and legal details stay on this device.',
          children: [
            ComponentListTile(
              key: const ValueKey<String>('section-version'),
              backgroundColor: Colors.transparent,
              title: const Text('Version'),
              trailing: Text('0.0.87', style: context.labelMedium.copyWith(color: context.hint)),
            ),
            ComponentListTile(
              key: const ValueKey<String>('section-legal'),
              backgroundColor: Colors.transparent,
              title: const Text('Legal'),
              trailing: Icon(Icons.chevron_right_rounded, color: context.hint),
              onTap: () => AlertSnackbar.show(message: 'Legal'),
            ),
          ],
        ),
      ],
    );
  }
}
