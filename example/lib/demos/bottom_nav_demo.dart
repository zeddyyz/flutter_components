import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class BottomNavDemoPage extends StatelessWidget {
  const BottomNavDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: ComponentBlurredAppBar(
        context: context,
        title: const Text('Bottom nav'),
        actions: const [ThemeToggleButton()],
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + kToolbarHeight + 8,
          left: context.defaultPadding,
          right: context.defaultPadding,
          bottom: 140,
        ),
        itemCount: 24,
        itemBuilder: (BuildContext context, int index) {
          final Color color = Colors.primaries[index % Colors.primaries.length];
          return Container(
            height: 96,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: ShapeDecoration(
              color: color.withValues(alpha: 0.45),
              shape: RoundedSuperellipseBorder(
                borderRadius: AppDecoration.borderRadiusXl,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 14,
              children: [
                DecoratedBox(
                  decoration: ShapeDecoration(color: color, shape: const CircleBorder()),
                  child: SizedBox.square(
                    dimension: 44,
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: context.bodyBold.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text('Row ${index + 1}', style: context.body2Heavy),
                      Text(
                        'Scroll so this text passes under the glass pills',
                        style: context.labelMedium.copyWith(
                          color: context.primary.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: context.primary.withValues(alpha: 0.5)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: ComponentBottomNavBar(
        isBackgroundFaded: true,
        childrenLeftAligned: [
          ComponentGestureClick(
            key: const ValueKey<String>('nav-home'),
            onTap: () => AlertSnackbar.show(message: 'Home'),
            child: const Icon(Icons.home_rounded, size: 32),
          ),
          ComponentGestureClick(
            key: const ValueKey<String>('nav-search'),
            onTap: () => AlertSnackbar.show(message: 'Search'),
            child: const Icon(Icons.search_rounded, size: 32),
          ),
        ],
        childrenRightAligned: [
          ComponentGestureClick(
            key: const ValueKey<String>('nav-add'),
            onTap: () => AlertSnackbar.show(message: 'Add'),
            child: const Icon(
              Icons.add_rounded,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
