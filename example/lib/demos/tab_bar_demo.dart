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
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + kToolbarHeight + 8),
          ComponentTabBar(
            numberOfItems: _tabs.length,
            tabs: _tabs,
            tabController: _controller,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                for (final String tab in _tabs)
                  ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      context.defaultPadding,
                      0,
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
          ),
        ],
      ),
    );
  }
}
