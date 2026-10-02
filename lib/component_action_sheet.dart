import 'package:flutter_components/component_responsive_modal.dart';
import 'package:flutter_components/component_slide_down_bar.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentActionSheetAction {
  const ComponentActionSheetAction({
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;
  final Widget? icon;
}

class ComponentActionSheet {
  static Future<void> show({
    required BuildContext context,
    required List<ComponentActionSheetAction> actions,
    String? title,
    String? message,
    String cancelLabel = 'Cancel',
  }) {
    return ComponentResponsiveModal.show<void>(
      context: context,
      title: title ?? '',
      showAppBar: true,
      float: true,
      constraints: BoxConstraints(
        maxWidth: 420,
        maxHeight: context.viewHeight * 0.7,
      ),
      builder: (BuildContext modalContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16, context.topPadding(0), 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ComponentSlideDownBar(),
              // if (title != null) ...[
              //   const SizedBox(height: 16),
              //   Text(title, style: modalContext.body2Heavy, textAlign: TextAlign.center),
              // ],
              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message,
                  style: modalContext.bodyMedium.copyWith(color: modalContext.hintIntense),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              for (int i = 0; i < actions.length; i++)
                _ActionRow(
                  key: ValueKey<String>('action-sheet-$i'),
                  action: actions[i],
                  onTap: () {
                    Navigator.pop(modalContext);
                    actions[i].onPressed();
                  },
                ),
              const SizedBox(height: 8),
              ComponentGestureClick(
                key: const ValueKey<String>('action-sheet-cancel'),
                semanticsLabel: cancelLabel,
                onTap: () => Navigator.pop(modalContext),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Text(cancelLabel, style: modalContext.body2Heavy),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    super.key,
    required this.action,
    required this.onTap,
  });

  final ComponentActionSheetAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = action.isDestructive ? context.componentTheme.dangerColor : context.primary;
    return ComponentGestureClick(
      semanticsLabel: action.label,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        margin: EdgeInsets.only(bottom: 10),
        decoration: ShapeDecoration(
          shape: RoundedSuperellipseBorder(
            borderRadius: AppDecoration.borderRadiusLg,
            side: BorderSide(
              color: context.componentTheme.borderColorIntense,
            ),
          ),
        ),
        child: Row(
          children: [
            if (action.icon != null) ...[
              IconTheme(
                data: IconThemeData(color: color, size: 22),
                child: action.icon!,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                action.label,
                style: context.body2Heavy.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
