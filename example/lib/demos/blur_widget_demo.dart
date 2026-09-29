import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class BlurWidgetDemoPage extends StatelessWidget {
  const BlurWidgetDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ComponentBlurredAppBar(
        context: context,
        title: const Text('Blurred widget'),
        actions: const [ThemeToggleButton()],
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + kToolbarHeight + 8,
              left: context.defaultPadding,
              right: context.defaultPadding,
              bottom: 160,
            ),
            itemCount: 20,
            itemBuilder: (BuildContext context, int index) {
              final Color color = Colors.primaries[index % Colors.primaries.length];
              return Container(
                height: 108,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: ShapeDecoration(
                  color: color.withValues(alpha: 0.45),
                  shape: RoundedSuperellipseBorder(
                    borderRadius: AppDecoration.borderRadiusXl,
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ComponentBlurredWidget(
              fadeTopEdge: true,
              tintColor: context.scaffoldBackgroundColor.withValues(alpha: 0.85),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.defaultPadding,
                    28,
                    context.defaultPadding,
                    16,
                  ),
                  child: ComponentCard(
                    displayBorder: true,
                    child: Text(
                      'ComponentBlurredWidget fades the backdrop above this card.',
                      style: context.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
