import 'package:flutter_components/component_close_button.dart';
import 'package:flutter_components/component_responsive_modal.dart';
import 'package:flutter_components/component_sliver_blurred_app_bar.dart';
import 'package:flutter_components/component_sliver_large_title_app_bar.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

/// The content of a [ComponentResponsiveModal.showWithActionsSimple] modal: a
/// [CustomScrollView] that starts with a pinned blurred app bar holding a close
/// button, the [title] and the [actions], followed by the [slivers].
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
  }) : _hasLargeTitle = false;

  /// Shows the [title] as an iOS-style large title under the app bar, which
  /// collapses into the app bar as the [slivers] scroll under it.
  const ComponentResponsiveModalWidget.largeTitle({
    super.key,
    required this.title,
    required this.slivers,
    this.actions,
  }) : _hasLargeTitle = true;

  final String title;

  /// Widgets shown at the end of the app bar, typically a submit button
  final List<Widget>? actions;

  /// The modal's content, scrolling under the pinned app bar
  final List<Widget> slivers;

  final bool _hasLargeTitle;

  static const _modalTopBorderRadius = BorderRadius.vertical(top: AppDecoration.iOSModalRadius);
  static const _actionsPadding = EdgeInsets.only(right: 8);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (_hasLargeTitle) _buildLargeTitleAppBar(context) else _buildAppBar(context),
        ...slivers,
        SliverToBoxAdapter(child: SizedBox(height: context.mediaQueryPadding.bottom)),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return ComponentSliverBlurredAppBar(
      context: context,
      title: Text(title, style: context.body2Heavy),
      centerTitle: true,
      toolbarHeight: kModalToolbarHeight,
      leading: const _ModalCloseButton(),
      actions: actions,
      actionsPadding: _actionsPadding,
      backgroundColor: context.bottomSheetTheme.backgroundColor,
      borderRadius: _modalTopBorderRadius,
    );
  }

  Widget _buildLargeTitleAppBar(BuildContext context) {
    return ComponentSliverLargeTitleAppBar(
      context: context,
      title: title,
      leading: const _ModalCloseButton(),
      actions: actions,
      actionsPadding: _actionsPadding,
      backgroundColor: context.bottomSheetTheme.backgroundColor,
      borderRadius: _modalTopBorderRadius,
      toolbarHeight: kModalToolbarHeight,
    );
  }
}

class _ModalCloseButton extends StatelessWidget {
  const _ModalCloseButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: ComponentCloseButton.blurred(backgroundColor: context.bottomSheetCardColor),
        ),
      ],
    );
  }
}
