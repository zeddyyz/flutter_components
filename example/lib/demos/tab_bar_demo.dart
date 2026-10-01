import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class TabBarDemoPage extends StatefulWidget {
  const TabBarDemoPage({super.key});

  @override
  State<TabBarDemoPage> createState() => _TabBarDemoPageState();
}

class _TabBarDemoPageState extends State<TabBarDemoPage> with TickerProviderStateMixin {
  static const List<String> _tabs = ['Inbox', 'Work', 'Personal', 'Updates', 'Archive'];
  late final TabController _controller = TabController(length: _tabs.length, vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ComponentBlurredAppBar(
        context: context,
        title: const Text('Tab bar'),
        actions: const [ThemeToggleButton()],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: ComponentTabBar(
            numberOfItems: _tabs.length,
            tabs: _tabs,
            tabController: _controller,
            isBlurred: false,
          ),
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          for (final String tab in _tabs)
            ListView.builder(
              padding: EdgeInsets.fromLTRB(
                context.defaultPadding,
                context.topPadding(120),
                context.defaultPadding,
                context.paddingBottom,
              ),
              itemCount: 16,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ComponentListTile(
                    displayBorder: true,
                    title: Text('$tab item ${index + 1}'),
                    subtitle: const Text('Swipe or tap a tab'),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
