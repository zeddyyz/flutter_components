import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class BlurredAppBarDemoPage extends StatelessWidget {
  const BlurredAppBarDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ComponentBlurredAppBar(
        context: context,
        title: const Text('Blurred app bar'),
        actions: const [ThemeToggleButton()],
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + kToolbarHeight + 8,
          left: context.defaultPadding,
          right: context.defaultPadding,
          bottom: context.paddingBottom,
        ),
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          final Color color = Colors.primaries[index % Colors.primaries.length];
          return Container(
            height: 88,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: ShapeDecoration(
              color: color.withValues(alpha: 0.4),
              shape: RoundedSuperellipseBorder(
                borderRadius: AppDecoration.borderRadiusLg,
              ),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Scroll under the bar  ${index + 1}', style: context.body2Heavy),
          );
        },
      ),
    );
  }
}
