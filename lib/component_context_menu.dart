import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentContextMenuItem {
  const ComponentContextMenuItem({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final bool isDestructive;
}

class ComponentContextMenu extends StatelessWidget {
  const ComponentContextMenu({
    super.key,
    required this.items,
    required this.child,
  });

  final List<ComponentContextMenuItem> items;
  final Widget child;

  Future<void> _show(BuildContext context, Offset globalPosition) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
    final int? selected = await showMenu<int>(
      context: context,
      position: RelativeRect.fromRect(
        globalPosition & const Size(1, 1),
        Offset.zero & overlay.size,
      ),
      shape: RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusLg),
      color: context.componentTheme.cardColor,
      items: [
        for (int i = 0; i < items.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: Row(
              children: [
                if (items[i].icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      size: 18,
                      color: items[i].isDestructive
                          ? context.componentTheme.dangerColor
                          : context.primary,
                    ),
                    child: items[i].icon!,
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  items[i].label,
                  style: context.bodyMedium.copyWith(
                    color: items[i].isDestructive
                        ? context.componentTheme.dangerColor
                        : context.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
    if (selected == null) return;
    items[selected].onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const ValueKey<String>('context-menu'),
      onLongPressStart: (LongPressStartDetails details) => _show(context, details.globalPosition),
      onSecondaryTapDown: (TapDownDetails details) => _show(context, details.globalPosition),
      child: child,
    );
  }
}
