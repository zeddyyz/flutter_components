import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class SliverAppBarDemoPage extends StatelessWidget {
  const SliverAppBarDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ComponentSliverBlurredAppBar(
            context: context,
            title: const Text('Sliver app bar'),
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
              itemCount: 28,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ComponentCard(
                    displayBorder: true,
                    child: Text('Sliver row ${index + 1}', style: context.body2Heavy),
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
