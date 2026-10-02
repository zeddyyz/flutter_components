import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:material_ui/material_ui.dart';

class ComponentAccordionItem {
  const ComponentAccordionItem({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;
}

class ComponentAccordion extends StatelessWidget {
  const ComponentAccordion({
    super.key,
    required this.items,
    required this.expandedIndex,
    required this.onExpandedIndexChanged,
  });

  final List<ComponentAccordionItem> items;
  final int? expandedIndex;
  final ValueChanged<int?> onExpandedIndexChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _AccordionRow(
            key: ValueKey<String>('accordion-$i'),
            item: items[i],
            expanded: expandedIndex == i,
            onTap: () => onExpandedIndexChanged(expandedIndex == i ? null : i),
          ),
          if (i != items.length - 1)
            Divider(height: 1, color: context.componentTheme.hairlineColor),
        ],
      ],
    );
  }
}

class _AccordionRow extends StatelessWidget {
  const _AccordionRow({
    super.key,
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final ComponentAccordionItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ComponentGestureClick(
          semanticsLabel: item.title,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
            child: Row(
              children: [
                Expanded(child: Text(item.title, style: context.body2Heavy)),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more_rounded, color: context.hintIntense),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: expanded
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: item.child,
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
