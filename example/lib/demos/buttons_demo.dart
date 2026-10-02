import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

void _noop() {}

class ButtonsDemoPage extends StatelessWidget {
  const ButtonsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Buttons',
      children: [
        DemoSection(
          title: 'ComponentButton',
          description: 'Every ButtonType against the shared theme.',
          child: Column(
            spacing: 12,
            children: [
              FilledButton(
                key: ValueKey<String>('button-filled'),
                onPressed: () {
                  AlertSnackbar.show(title: 'FilledButton', message: 'FilledButton pressed');
                },
                child: Text('FilledButton'),
              ),
              ElevatedButton(
                key: ValueKey<String>('button-elevated'),
                onPressed: () {
                  AlertSnackbar.show(title: 'ElevatedButton', message: 'ElevatedButton pressed');
                },
                child: Text('ElevatedButton'),
              ),
              OutlinedButton(
                key: ValueKey<String>('button-outlined'),
                onPressed: () {
                  AlertSnackbar.show(title: 'OutlinedButton', message: 'OutlinedButton pressed');
                },
                child: Text('OutlinedButton'),
              ),
              TextButton(
                key: ValueKey<String>('button-text'),
                onPressed: () {
                  AlertSnackbar.show(title: 'TextButton', message: 'TextButton pressed');
                },
                child: Text('TextButton'),
              ),
              ComponentDangerButton(
                key: ValueKey<String>('button-danger'),
                onPressed: () {
                  AlertSnackbar.show(
                    title: 'ComponentDangerButton',
                    message: 'ComponentDangerButton pressed',
                  );
                },
                child: Text('ComponentDangerButton'),
              ),
              Row(
                spacing: 12,
                mainAxisAlignment: .center,
                children: [
                  ComponentIconButton(
                    key: ValueKey<String>('button-icon'),
                    isFilled: false,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      AlertSnackbar.show(
                        title: 'ComponentIconButton',
                        message: 'ComponentIconButton pressed',
                      );
                    },
                  ),
                  ComponentIconButton(
                    key: ValueKey<String>('button-icon-label'),
                    isFilled: false,
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                    onPressed: () {
                      AlertSnackbar.show(
                        title: 'ComponentIconButton',
                        message: 'ComponentIconButton pressed',
                      );
                    },
                  ),
                  ComponentIconButton(
                    key: ValueKey<String>('button-icon-filled'),
                    isFilled: true,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      AlertSnackbar.show(
                        title: 'ComponentIconButton',
                        message: 'ComponentIconButton pressed',
                      );
                    },
                  ),
                  ComponentIconButton(
                    key: ValueKey<String>('button-icon-label-filled'),
                    isFilled: true,
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                    onPressed: () {
                      AlertSnackbar.show(
                        title: 'ComponentIconButton',
                        message: 'ComponentIconButton pressed',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'ComponentLightButton',
          description: 'Default surface vs modal-sheet surface.',
          child: Column(
            spacing: 12,
            children: [
              ComponentLightButton(
                key: const ValueKey<String>('light-button'),
                onPressed: () => AlertSnackbar.show(message: 'Light button'),
                child: const Text('Default'),
              ),
              ComponentLightButton(
                key: const ValueKey<String>('light-button-sheet'),
                isModalSheet: true,
                onPressed: () => AlertSnackbar.show(message: 'Modal sheet light button'),
                child: const Text('Modal sheet'),
              ),
              const ComponentLightButton(
                key: ValueKey<String>('light-button-loading'),
                isLoading: true,
                onPressed: _noop,
                child: Text('Loading'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Back, close, and gesture click',
          child: ComponentCard(
            displayBorder: true,
            backgroundColor: Colors.transparent,
            child: Column(
              children: [
                Row(
                  children: [
                    const ComponentBackButton(),
                    const SizedBox(width: 12),
                    Text('ComponentBackButton', style: context.bodyMedium),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const ComponentBackButton.blurred(),
                    const SizedBox(width: 12),
                    Text('ComponentBackButton in AppBar (blurred)', style: context.bodyMedium),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const ComponentCloseButton(),
                    const SizedBox(width: 12),
                    Text('ComponentCloseButton', style: context.bodyMedium),
                  ],
                ),
                const SizedBox(height: 16),
                ComponentGestureClick(
                  key: const ValueKey<String>('gesture-click'),
                  semanticsLabel: 'Gesture click sample',
                  onTap: () => AlertSnackbar.show(message: 'ComponentGestureClick'),
                  child: Text(
                    'Tap this label (ComponentGestureClick)',
                    style: context.body2Heavy,
                  ),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Blurred close button',
          description: 'Needs content behind it to show the backdrop blur.',
          child: ClipRSuperellipse(
            borderRadius: AppDecoration.borderRadiusXl,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4C6FFF), Color(0xFF9B5CFF), Color(0xFFFF7A59)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: ComponentCloseButton.blurred(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
