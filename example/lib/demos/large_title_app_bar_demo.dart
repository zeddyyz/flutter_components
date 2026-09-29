import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class LargeTitleAppBarDemoPage extends StatelessWidget {
  const LargeTitleAppBarDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ComponentSliverLargeTitleAppBar(
            context: context,
            title: 'Summary',
            subtitle: 'The large title fades as this list collapses.',
            expandedTrailing: CircleAvatar(
              backgroundColor: context.chipColor,
              foregroundColor: context.primary,
              child: const Text('FC'),
            ),
            actions: const [ThemeToggleButton()],
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              context.defaultPadding,
              8,
              context.defaultPadding,
              context.paddingBottom,
            ),
            sliver: SliverList.builder(
              itemCount: 24,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ComponentListTile(
                    displayBorder: true,
                    leading: Icon(Icons.circle, color: context.hint, size: 12),
                    title: Text('Activity ${index + 1}'),
                    subtitle: const Text('Scroll to collapse the title'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
