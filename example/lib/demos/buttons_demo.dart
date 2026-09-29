import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

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
              for (final ButtonType type in ButtonType.values)
                ComponentButton(
                  key: ValueKey<String>('button-${type.name}'),
                  buttonType: type,
                  style: type == ButtonType.filled
                      ? FilledButton.styleFrom(
                          foregroundColor: context.scaffoldBackgroundColor,
                        )
                      : null,
                  onPressed: () {
                    AlertSnackbar.show(title: type.name, message: 'ComponentButton pressed');
                  },
                  child: Text(type.name),
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
            ],
          ),
        ),
        DemoSection(
          title: 'Back, close, and gesture click',
          child: ComponentCard(
            displayBorder: true,
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
