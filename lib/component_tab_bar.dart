import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

class ComponentTabBar extends StatefulWidget {
  const ComponentTabBar({
    super.key,
    required this.numberOfItems,
    required this.tabs,
    required this.tabController,
    this.height = 45,
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

class _ComponentTabBarState extends State<ComponentTabBar> with TickerProviderStateMixin {
  // Tab keys to get tab positions for smooth scrolling
  late List<GlobalKey> _tabKeys;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabKeys = List.generate(widget.numberOfItems, (_) => GlobalKey());
    // Add listener to handle tab changes
    widget.tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabChange);
    // Don't dispose the controller since it was provided externally
    // and may still be used by other widgets
    super.dispose();
  }

  void _handleTabChange() {
    // Only respond when the animation is done
    if (!widget.tabController.indexIsChanging) {
      // User has changed the tab
      // Scroll the selected tab into view
      _scrollTabIntoView(widget.tabController.index);
    }
  }

  void _selectTab(int index) {
    if (widget.tabController.index == index) return;

    // Immediately animate to the selected tab
    // widget.tabController.animateTo(
    //   index,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );
    setState(() {
      _selectedIndex = index;
    });
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
    if (isBlurred) {
      return context.isLightMode
          ? Colors.grey.shade200.withValues(alpha: 0.6)
          : Colors.grey.shade900.withValues(alpha: 0.6);
    }

    if (widget.backgroundColor != null) {
      return widget.backgroundColor!;
    }

    return context.isLightMode ? Colors.grey.shade200 : Colors.grey.shade900;
  }

  Color _getSelectedIndicatorColor(BuildContext context, bool isBlurred) {
    if (isBlurred) {
      return context.isLightMode ? Colors.white.withValues(alpha: 0.7) : Colors.grey.shade900;
    }

    if (widget.selectedColor != null) {
      return widget.selectedColor!;
    }

    return context.isLightMode ? Colors.white : Colors.grey.shade800;
  }

  Color _getUnselectedIndicatorColor(BuildContext context, bool isBlurred) {
    return context.isLightMode ? Colors.grey.shade200 : Colors.grey.shade900;
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
            color: widget.tabController.index == _selectedIndex
                ? _getSelectedIndicatorColor(context, isBlurred)
                : _getUnselectedIndicatorColor(context, isBlurred),
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
          tabs: widget.tabs.map(
            (tab) {
              final tabIndex = widget.tabs.indexOf(tab);
              return Tab(
                key: _tabKeys[tabIndex],
                text: tab,
              );
            },
          ).toList(),
          enableFeedback: true,
          onTap: (index) => _selectTab(index),
        ),
      ),
    );
  }
}
