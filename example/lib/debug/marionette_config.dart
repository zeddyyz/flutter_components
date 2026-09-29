import 'package:flutter_components/flutter_components.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

MarionetteConfiguration exampleMarionetteConfiguration() {
  return MarionetteConfiguration(
    logCollector: PrintLogCollector(),
    isInteractiveWidget: (Type type) =>
        type == ComponentCard ||
        type == ComponentDangerButton ||
        type == ComponentLightButton ||
        type == ComponentGestureClick ||
        type == ComponentPill ||
        type == ComponentFilterChip ||
        type == ComponentBackButton ||
        type == ComponentCloseButton ||
        type == ComponentListTile,
  );
}
