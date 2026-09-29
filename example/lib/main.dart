import 'package:example/debug/marionette_config.dart';
import 'package:example/example_app.dart';
import 'package:flutter/foundation.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized(exampleMarionetteConfiguration());
  }
  runApp(const ExampleApp());
}
