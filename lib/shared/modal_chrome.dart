import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

const BorderRadius kModalTopBorderRadius = BorderRadius.vertical(
  top: AppDecoration.iOSModalRadius,
);

/// Height of the sheet grabber, including the padding around [ComponentSlideDownBar].
const double kSheetHandleExtent = 19;

Color modalBarrierColor(BuildContext context) {
  return context.isLightMode ? Colors.black45 : Colors.black.withValues(alpha: 0.7);
}

Widget clipModalChrome({
  required BorderRadius borderRadius,
  required Widget child,
}) {
  return ClipRSuperellipse(
    borderRadius: borderRadius,
    clipBehavior: .antiAliasWithSaveLayer,
    child: child,
  );
}
