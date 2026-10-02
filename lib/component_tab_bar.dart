import 'dart:ui';

import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentTabBar extends StatefulWidget {
  const ComponentTabBar({
    super.key,
    required this.numberOfItems,
    required this.tabs,
    required this.tabController,
    this.height = AppDecoration.pillTrackHeight,
    this.backgroundColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.selectedColor,
    this.unselectedColor,
    this.marginHorizontal,
    this.isBlurred = false,
    this.blurSigmaX,
    this.blurSigmaY,
  });

  final TabController tabController;
  final int numberOfItems;
  final List<String> tabs;

  /// Styling
  final double? height;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? marginHorizontal;

  final bool isBlurred;
  final double? blurSigmaX;
  final double? blurSigmaY;

  @override
  State<ComponentTabBar> createState() => _ComponentTabBarState();
}

class _ComponentTabBarState extends State<ComponentTabBar> {
  // Tab keys to get tab positions for smooth scrolling
  late List<GlobalKey> _tabKeys;

  @override
  void initState() {
    super.initState();
    _tabKeys = List.generate(widget.numberOfItems, (_) => GlobalKey());
    widget.tabController.addListener(_handleTabChange);
  }

  @override
  void didUpdateWidget(ComponentTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabController != widget.tabController) {
      oldWidget.tabController.removeListener(_handleTabChange);
      widget.tabController.addListener(_handleTabChange);
    }
    if (oldWidget.numberOfItems != widget.numberOfItems) {
      _tabKeys = List.generate(widget.numberOfItems, (_) => GlobalKey());
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  void _handleTabChange() {
    if (!widget.tabController.indexIsChanging) {
      _scrollTabIntoView(widget.tabController.index);
    }
  }

  void _scrollTabIntoView(int index) {
    if (index < 0 || index >= _tabKeys.length) return;

    final tabKey = _tabKeys[index];
    final renderBox = tabKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      // Ensure the selected tab is visible in the viewport
      Scrollable.ensureVisible(
        tabKey.currentContext!,
        alignment: 0.9, // Center in viewport
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBlurred) {
      return RepaintBoundary(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.blurSigmaX ?? 15,
              sigmaY: widget.blurSigmaY ?? 15,
            ),
            child: _buildTabBar(context, true),
          ),
        ),
      );
    }
    return _buildTabBar(context, false);
  }

  Color _getBackgroundColor(BuildContext context, bool isBlurred) {
    return widget.backgroundColor ?? AppDecoration.pillTrackColor(context, isBlurred: isBlurred);
  }

  Color _getSelectedIndicatorColor(BuildContext context, bool isBlurred) {
    return widget.selectedColor ?? AppDecoration.pillThumbColor(context, isBlurred: isBlurred);
  }

  Widget _buildTabBar(BuildContext context, bool isBlurred) {
    return ClipRSuperellipse(
      borderRadius: AppDecoration.borderRadiusStadium,
      child: Container(
        height: widget.height,
        margin: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: widget.marginHorizontal ?? context.defaultPadding,
        ),
        padding: const EdgeInsets.only(left: 2, right: 2),
        decoration: ShapeDecoration(
          color: _getBackgroundColor(context, isBlurred),
          shape: RoundedSuperellipseBorder(
            borderRadius: AppDecoration.borderRadiusStadium,
          ),
        ),
        child: TabBar(
          controller: widget.tabController,
          indicatorColor: context.primary,
          indicatorWeight: 2,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: ShapeDecoration(
            color: _getSelectedIndicatorColor(context, isBlurred),
            shape: RoundedSuperellipseBorder(
              borderRadius: AppDecoration.borderRadiusStadium,
            ),
          ),
          labelColor: widget.labelColor ?? context.primary,
          unselectedLabelColor:
              widget.unselectedLabelColor ?? context.primary.withValues(alpha: 0.6),
          labelStyle: context.textTheme.bodyMedium,
          unselectedLabelStyle: context.textTheme.bodyMedium,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          dividerColor: Colors.transparent,
          dividerHeight: 0,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
          tabs: [
            for (int i = 0; i < widget.numberOfItems; i++)
              KeyedSubtree(
                key: ValueKey('tab-$i'),
                child: Tab(
                  key: _tabKeys[i],
                  text: widget.tabs[i],
                ),
              ),
          ],
          enableFeedback: true,
        ),
      ),
    );
  }
}
