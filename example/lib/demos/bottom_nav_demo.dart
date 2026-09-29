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
              color: color.withValues(alpha: 0.35),
              shape: RoundedSuperellipseBorder(
                borderRadius: AppDecoration.borderRadiusXl,
              ),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Row ${index + 1}', style: context.body2Heavy),
          );
        },
      ),
      bottomNavigationBar: ComponentBottomNavBar(
        isBackgroundFaded: true,
        childrenLeftAligned: [
          IconButton(
            key: const ValueKey<String>('nav-home'),
            tooltip: 'Home',
            onPressed: () => AlertSnackbar.show(message: 'Home'),
            icon: const Icon(Icons.home_rounded),
          ),
          IconButton(
            key: const ValueKey<String>('nav-search'),
            tooltip: 'Search',
            onPressed: () => AlertSnackbar.show(message: 'Search'),
            icon: const Icon(Icons.search_rounded),
          ),
        ],
        childrenRightAligned: [
          IconButton(
            key: const ValueKey<String>('nav-add'),
            tooltip: 'Add',
            onPressed: () => AlertSnackbar.show(message: 'Add'),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
