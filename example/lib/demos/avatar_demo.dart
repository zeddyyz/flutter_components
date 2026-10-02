import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class AvatarDemoPage extends StatelessWidget {
  const AvatarDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Avatar',
      children: [
        DemoSection(
          title: 'Initials',
          child: const Wrap(
            spacing: 16,
            children: [
              ComponentAvatar(initials: 'Ada Lovelace', size: 48),
              ComponentAvatar(initials: 'Zedd', size: 48),
              ComponentAvatar(size: 48),
            ],
          ),
        ),
        DemoSection(
          title: 'Group',
          child: const ComponentAvatarGroup(
            avatars: [
              ComponentAvatar(initials: 'AL'),
              ComponentAvatar(initials: 'ZY'),
              ComponentAvatar(initials: 'MK'),
              ComponentAvatar(initials: 'RS'),
            ],
          ),
        ),
      ],
    );
  }
}
