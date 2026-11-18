import 'package:flutter_components/component_close_button.dart';
import 'package:flutter_components/component_responsive_modal.dart';
import 'package:flutter_components/component_sliver_blurred_app_bar.dart';
import 'package:flutter_components/component_sliver_large_title_app_bar.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/bottom_sheet_extent.dart';
import 'package:flutter_components/shared/modal_chrome.dart';
import 'package:material_ui/material_ui.dart';

/// The content of a [ComponentResponsiveModal.showWithActionsSimple] modal or a
/// [ComponentBottomSheet]: a [CustomScrollView] that starts with a pinned
/// blurred app bar holding a close button, the [title] and the [actions],
/// followed by the [slivers].
///
/// Return it from the `build` of the widget the modal's builder creates. The
/// [actions] are then built from that widget's state, so they can validate and
/// submit it directly and close the modal with `Navigator.pop(context, result)`:
///
/// ```dart
/// class _EditNameFormState extends State<EditNameForm> {
///   @override
///   Widget build(BuildContext context) {
///     return ComponentResponsiveModalWidget(
///       title: 'Edit name',
///       actions: [
///         TextButton(
///           onPressed: _name.text.isEmpty ? null : () => Navigator.pop(context, _name.text),
///           child: const Text('Save'),
///         ),
///       ],
///       slivers: [
///         SliverPadding(
///           padding: const EdgeInsets.all(20),
///           sliver: SliverToBoxAdapter(child: TextField(controller: _name)),
///         ),
///       ],
///     );
///   }
/// }
/// ```
class ComponentResponsiveModalWidget extends StatelessWidget {
  /// Shows the [title] centered in the app bar, like [ComponentResponsiveModal.show].
  const ComponentResponsiveModalWidget({
    super.key,
    required this.title,
    required this.slivers,
    this.actions,
    this.footer,
  }) : _hasLargeTitle = false;

  /// Shows the [title] as an iOS-style large title under the app bar, which
  /// collapses into the app bar as the [slivers] scroll under it.
  const ComponentResponsiveModalWidget.largeTitle({
    super.key,
    required this.title,
    required this.slivers,
    this.actions,
    this.footer,
  }) : _hasLargeTitle = true;

  final String title;

  /// Widgets shown at the end of the app bar, typically a submit button
  final List<Widget>? actions;

  /// The modal's content, scrolling under the pinned app bar
  final List<Widget> slivers;

  /// Sticky bar pinned below the [slivers], above the bottom safe area and keyboard.
  final Widget? footer;

  final bool _hasLargeTitle;

  static const _actionsPadding = EdgeInsets.only(right: 8);

  @override
  Widget build(BuildContext context) {
    final ComponentBottomSheetScope? sheet = ComponentBottomSheetScope.maybeOf(context);
    final bool padBottomSafeArea = footer == null && (sheet?.padBottomSafeArea ?? true);

    final Widget scrollView = CustomScrollView(
      controller: sheet?.scrollController,
      shrinkWrap: sheet?.shrinkWrap ?? false,
      slivers: [
        if (_hasLargeTitle)
          _buildLargeTitleAppBar(context, sheet?.handle)
        else
          _buildAppBar(context, sheet?.handle),
        ...slivers,
        if (padBottomSafeArea)
          SliverToBoxAdapter(child: SizedBox(height: context.mediaQueryPadding.bottom)),
      ],
    );

    final Widget? footerWidget = footer;
    if (footerWidget == null) return scrollView;

    final Widget footerBar = _ModalFooter(child: footerWidget);
    if (sheet?.shrinkWrap ?? false) {
      return Column(
        mainAxisSize: .min,
        children: [scrollView, footerBar],
      );
    }
    return Column(
      children: [
        Expanded(child: scrollView),
        footerBar,
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, Widget? handle) {
    return ComponentSliverBlurredAppBar(
      context: context,
      title: Text(title, style: context.textTheme.headline),
      centerTitle: true,
      toolbarHeight: kModalToolbarHeight,
      leading: ComponentCloseButton.blurred(
        backgroundColor: context.bottomSheetCardColor,
        isInAppBar: true,
      ),
      actions: actions,
      actionsPadding: _actionsPadding,
      backgroundColor: context.bottomSheetTheme.backgroundColor,
      borderRadius: kModalTopBorderRadius,
      handle: handle,
    );
  }

  Widget _buildLargeTitleAppBar(BuildContext context, Widget? handle) {
    return ComponentSliverLargeTitleAppBar(
      context: context,
      title: title,
      leading: ComponentCloseButton.blurred(
        backgroundColor: context.bottomSheetCardColor,
        isInAppBar: true,
      ),
      actions: actions,
      actionsPadding: _actionsPadding,
      backgroundColor: context.bottomSheetTheme.backgroundColor,
      borderRadius: kModalTopBorderRadius,
      toolbarHeight: kModalToolbarHeight,
      handle: handle,
    );
  }
}

class _ModalFooter extends StatelessWidget {
  const _ModalFooter({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ComponentBottomSheetScope? sheet = ComponentBottomSheetScope.maybeOf(context);
    final double bottom = (sheet?.padBottomSafeArea ?? true)
        ? MediaQuery.paddingOf(context).bottom
        : 0;
    final Widget footer = Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottom),
      child: child,
    );
    final BottomSheetExtent? extent = sheet?.extent;
    if (extent == null || !extent.enableDrag) return footer;
    return GestureDetector(
      behavior: .opaque,
      onVerticalDragUpdate: (DragUpdateDetails details) {
        extent.applyDragDelta(details.delta.dy);
      },
      onVerticalDragEnd: (DragEndDetails details) {
        extent.settle(expandVelocity: -details.velocity.pixelsPerSecond.dy);
      },
      child: footer,
    );
  }
}
