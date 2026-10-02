import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class PatternsDemoPage extends StatefulWidget {
  const PatternsDemoPage({super.key});

  @override
  State<PatternsDemoPage> createState() => _PatternsDemoPageState();
}

class _PatternsDemoPageState extends State<PatternsDemoPage> {
  String _otp = '';
  int _step = 1;
  final List<String> _items = List<String>.generate(12, (int i) => 'Row ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Patterns',
      children: [
        DemoSection(
          title: 'OTP field',
          child: ComponentOtpField(
            length: 4,
            onChanged: (String value) => setState(() => _otp = value),
            onCompleted: (String value) => AlertSnackbar.show(title: 'Code', message: value),
          ),
        ),
        if (_otp.isNotEmpty)
          Text('Current: $_otp', style: context.labelMedium.copyWith(color: context.hintIntense)),
        DemoSection(
          title: 'Stepper',
          child: Column(
            spacing: 16,
            children: [
              ComponentStepper(
                labels: const ['Cart', 'Ship', 'Pay'],
                currentStep: _step,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: _step == 0 ? null : () => setState(() => _step -= 1),
                    child: const Text('Back'),
                  ),
                  TextButton(
                    onPressed: _step == 2 ? null : () => setState(() => _step += 1),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Context menu',
          description: 'Long-press or right-click the card.',
          child: ComponentContextMenu(
            items: [
              ComponentContextMenuItem(
                label: 'Duplicate',
                icon: const Icon(Icons.copy_outlined),
                onPressed: () => AlertSnackbar.show(message: 'Duplicated'),
              ),
              ComponentContextMenuItem(
                label: 'Delete',
                isDestructive: true,
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () => AlertSnackbar.show(isError: true, message: 'Deleted'),
              ),
            ],
            child: const ComponentCard(
              displayBorder: true,
              child: Text('Press and hold'),
            ),
          ),
        ),
        DemoSection(
          title: 'Action sheet',
          child: OutlinedButton(
            key: const ValueKey<String>('action-sheet-show'),
            onPressed: () {
              ComponentActionSheet.show(
                context: context,
                title: 'Photo',
                actions: [
                  ComponentActionSheetAction(
                    label: 'Take photo',
                    icon: const Icon(Icons.photo_camera_outlined),
                    onPressed: () => AlertSnackbar.show(message: 'Camera'),
                  ),
                  ComponentActionSheetAction(
                    label: 'Delete',
                    isDestructive: true,
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () => AlertSnackbar.show(isError: true, message: 'Deleted'),
                  ),
                ],
              );
            },
            child: const Text('Show action sheet'),
          ),
        ),
        DemoSection(
          title: 'Refresh control',
          child: SizedBox(
            height: 220,
            child: ComponentRefreshControl(
              onRefresh: () async {
                await Future<void>.delayed(const Duration(milliseconds: 600));
                if (!mounted) return;
                AlertSnackbar.show(message: 'Refreshed');
              },
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text(_items[index]));
                },
              ),
            ),
          ),
        ),
        const DemoSection(
          title: 'Network image',
          description: 'Uses a public placeholder. Shows a skeleton while loading.',
          child: ComponentNetworkImage(
            url: 'https://picsum.photos/640/280',
            height: 160,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
