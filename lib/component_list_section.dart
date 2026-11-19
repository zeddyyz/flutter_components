import 'package:flutter_components/component_card.dart';
import 'package:flutter_components/component_theme.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:material_ui/material_ui.dart';

/// iOS inset-grouped list: one [ComponentCard] with hairline dividers.
///
/// Pass `backgroundColor: Colors.transparent` on [ComponentListTile] children
/// so tiles share this section card instead of drawing their own. When
/// [isInSheet] is true, also pass `isWithinBottomSheet: true` on those tiles.
class ComponentListSection extends StatelessWidget {
  const ComponentListSection({
    super.key,
    this.header,
    required this.children,
    this.footer,
    this.isInSheet = false,
    this.dividerIndent = 20,
    this.dividerEndIndent = 0,
  });

  final String? header;
  final List<Widget> children;
  final String? footer;
  final bool isInSheet;
  final double dividerIndent;
  final double dividerEndIndent;

  @override
  Widget build(BuildContext context) {
    final ComponentThemeData componentTheme = context.componentTheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                header!,
                style: context.textTheme.bodySmall?.semibold.copyWith(
                  color: componentTheme.hintColor,
                ),
              ),
            ),
          ComponentCard(
            padding: EdgeInsets.zero,
            displayBorder: false,
            isInSheet: isInSheet,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int index = 0; index < children.length; index++) ...[
                  children[index],
                  if (index < children.length - 1)
                    Divider(
                      thickness: 0.6,
                      height: 0.5,
                      color: componentTheme.hairlineColor,
                      indent: dividerIndent,
                      endIndent: dividerEndIndent,
                    ),
                  // SizedBox(
                  //   height: 0.5,
                  //   width: double.infinity,
                  //   child: ColoredBox(color: componentTheme.hairlineColor),
                  // ),
                ],
              ],
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                footer!,
                style: context.textTheme.labelMedium?.copyWith(color: componentTheme.hintColor),
              ),
            ),
        ],
      ),
    );
  }
}
