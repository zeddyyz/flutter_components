import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_components/shared/modal_chrome.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  group('ComponentResponsiveModal clipping', () {
    testWidgets('phone sheet clips content to the rounded corners with a save layer', (
      WidgetTester tester,
    ) async {
      await _openModal(tester);
      expect(
        _hasSaveLayerClip(tester, kModalTopBorderRadius),
        isTrue,
      );
    });

    testWidgets('large-screen dialog clips content to the rounded corners with a save layer', (
      WidgetTester tester,
    ) async {
      await _openModal(tester, surfaceSize: const Size(1024, 800));
      expect(find.byType(Dialog), findsOneWidget);
      expect(tester.widget<Dialog>(find.byType(Dialog)).clipBehavior, Clip.antiAlias);
      expect(
        _hasSaveLayerClip(tester, AppDecoration.iOSModalBorderRadius),
        isTrue,
      );
    });
  });
}

bool _hasSaveLayerClip(WidgetTester tester, BorderRadiusGeometry borderRadius) {
  return tester
      .widgetList<ClipRSuperellipse>(find.byType(ClipRSuperellipse))
      .any(
        (ClipRSuperellipse clip) =>
            clip.clipBehavior == Clip.antiAliasWithSaveLayer && clip.borderRadius == borderRadius,
      );
}

Future<void> _openModal(
  WidgetTester tester, {
  Size surfaceSize = const Size(400, 800),
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await pumpComponentApp(
    tester,
    surfaceSize: surfaceSize,
    child: Builder(
      builder: (BuildContext context) {
        return FilledButton(
          onPressed: () {
            ComponentResponsiveModal.show<void>(
              context: context,
              title: 'Bottom sheet',
              builder: (BuildContext context) {
                return ListView(
                  children: const [
                    ListTile(title: Text('Alan Turing')),
                    ListTile(title: Text('Grace Hopper')),
                    ListTile(title: Text('Katherine Johnson')),
                    ListTile(title: Text('Linus Torvalds')),
                  ],
                );
              },
            );
          },
          child: const Text('Open'),
        );
      },
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}
