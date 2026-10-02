import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class BadgeDemoPage extends StatelessWidget {
  const BadgeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Badge',
      children: [
        DemoSection(
          title: 'Count',
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: const [
              ComponentBadge(count: 3, child: Icon(Icons.notifications_outlined, size: 28)),
              ComponentBadge(count: 120, child: Icon(Icons.mail_outline_rounded, size: 28)),
              ComponentBadge(count: 8),
            ],
          ),
        ),
        DemoSection(
          title: 'Dot',
          child: const ComponentBadge.dot(
            child: Icon(Icons.chat_bubble_outline_rounded, size: 28),
          ),
        ),
      ],
    );
  }
}
