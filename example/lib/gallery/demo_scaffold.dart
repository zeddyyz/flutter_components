import 'package:example/example_app.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeMode mode = ExampleApp.of(context).themeMode;
    final bool isDark = mode == ThemeMode.dark || (mode == ThemeMode.system && context.isDarkMode);
    return IconButton(
      key: const ValueKey<String>('theme-toggle'),
      tooltip: isDark ? 'Switch to light theme' : 'Switch to dark theme',
      onPressed: ExampleApp.of(context).toggleTheme,
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
    );
  }
}

class DemoScaffold extends StatelessWidget {
  const DemoScaffold({
    super.key,
    required this.title,
    required this.children,
    this.bottomNavigationBar,
    this.extendBody = false,
  });

  final String title;
  final List<Widget> children;
  final Widget? bottomNavigationBar;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top + kToolbarHeight + 12;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: extendBody,
      appBar: ComponentBlurredAppBar(
        context: context,
        title: Text(title),
        actions: const [ThemeToggleButton()],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          context.defaultPadding,
          topInset,
          context.defaultPadding,
          context.paddingBottom,
        ),
        children: children,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class DemoSection extends StatelessWidget {
  const DemoSection({
    super.key,
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.body2Heavy),
          if (description != null) ...[
            const SizedBox(height: 6),
            Text(
              description!,
              style: context.bodyMedium.copyWith(color: context.hintIntense),
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
