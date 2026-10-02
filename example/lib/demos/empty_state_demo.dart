import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class EmptyStateDemoPage extends StatelessWidget {
  const EmptyStateDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Empty state',
      children: [
        DemoSection(
          title: 'Empty inbox',
          description: 'Default empty state with an inbox icon.',
          child: SizedBox(
            height: 280,
            child: ComponentEmptyState(
              icon: const Icon(Icons.inbox_outlined),
              title: 'Inbox is empty',
              message: 'Messages you receive will show up here.',
            ),
          ),
        ),
        DemoSection(
          title: 'Error',
          description: 'Error variant with a retry action.',
          child: SizedBox(
            height: 320,
            child: ComponentEmptyState.error(
              icon: const Icon(Icons.error_outline_rounded),
              title: 'Couldn’t load messages',
              message: 'Check your connection and try again.',
              action: ComponentLightButton(
                onPressed: () => AlertSnackbar.show(message: 'Retrying…'),
                child: const Text('Retry'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
