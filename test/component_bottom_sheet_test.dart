import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_components/shared/bottom_sheet_extent.dart';
import 'package:flutter_components/shared/modal_chrome.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  group('resolveSnapHeights', () {
    test('scales fractions to pixels and sorts them', () {
      expect(
        resolveSnapHeights(snapPoints: const [0.9, 0.4], availableHeight: 1000),
        [400, 900],
      );
    });

    test('clamps to the available height', () {
      expect(
        resolveSnapHeights(snapPoints: const [0.5, 1.5], availableHeight: 800),
        [400, 800],
      );
    });

    test('drops zero-height and duplicate snaps', () {
      expect(
        resolveSnapHeights(snapPoints: const [0, 0.5, 0.5, 1], availableHeight: 1000),
        [500, 1000],
      );
    });
  });

  group('nearestSnapIndex', () {
    test('returns the closest snap', () {
      expect(
        nearestSnapIndex(snapHeights: const [200, 500, 900], extent: 560),
        1,
      );
      expect(
        nearestSnapIndex(snapHeights: const [200, 500, 900], extent: 200),
        0,
      );
    });
  });

  group('targetSnapIndex', () {
    const List<double> snaps = [200, 500, 900];

    test('picks the nearest snap when velocity is low', () {
      expect(
        targetSnapIndex(snapHeights: snaps, extent: 360, velocity: 0),
        1,
      );
      expect(
        targetSnapIndex(snapHeights: snaps, extent: 250, velocity: 50),
        0,
      );
    });

    test('picks the next snap in the velocity direction', () {
      expect(
        targetSnapIndex(snapHeights: snaps, extent: 500, velocity: 400),
        2,
      );
      expect(
        targetSnapIndex(snapHeights: snaps, extent: 500, velocity: -400),
        0,
      );
    });

    test('stays at the ends when there is no further snap', () {
      expect(
        targetSnapIndex(snapHeights: snaps, extent: 900, velocity: 800),
        2,
      );
      expect(
        targetSnapIndex(snapHeights: snaps, extent: 200, velocity: -800),
        0,
      );
    });
  });

  group('shouldDismissSheet', () {
    test('is true once the sheet is dragged past half its height', () {
      expect(
        shouldDismissSheet(dismissOffset: 251, sheetHeight: 500, downwardVelocity: 0),
        isTrue,
      );
      expect(
        shouldDismissSheet(dismissOffset: 100, sheetHeight: 500, downwardVelocity: 0),
        isFalse,
      );
    });

    test('is true when the downward fling reaches the dismiss velocity', () {
      expect(
        shouldDismissSheet(
          dismissOffset: 10,
          sheetHeight: 500,
          downwardVelocity: kBottomSheetDismissVelocity,
        ),
        isTrue,
      );
    });
  });

  group('BottomSheetExtent', () {
    test('starts at the requested snap', () {
      final BottomSheetExtent extent = BottomSheetExtent(
        snapPoints: const [0.4, 0.9],
        availableHeight: 1000,
        initialSnapIndex: 1,
      );
      expect(extent.extent, 900);
      expect(extent.snapIndex, 1);
      expect(extent.minHeight, 400);
      expect(extent.maxHeight, 900);
    });

    test('collapses then converts leftover drag into dismissOffset', () {
      final BottomSheetExtent extent = BottomSheetExtent(
        snapPoints: const [0.4, 0.9],
        availableHeight: 1000,
        initialSnapIndex: 1,
      );

      extent.applyDragDelta(200);
      expect(extent.extent, 700);
      expect(extent.dismissOffset, 0);

      extent.applyDragDelta(400);
      expect(extent.extent, 400);
      expect(extent.dismissOffset, 100);
    });

    test('recovers dismissOffset before expanding', () {
      final BottomSheetExtent extent = BottomSheetExtent(
        snapPoints: const [0.4, 0.9],
        availableHeight: 1000,
      );
      extent.applyDragDelta(80);
      expect(extent.dismissOffset, 80);

      extent.applyDragDelta(-50);
      expect(extent.dismissOffset, 30);
      expect(extent.extent, 400);

      extent.applyDragDelta(-80);
      expect(extent.dismissOffset, 0);
      expect(extent.extent, 450);
    });

    test('content-sized sheets only move dismissOffset', () {
      final BottomSheetExtent extent = BottomSheetExtent(
        availableHeight: 1000,
        contentHeight: 300,
      );
      expect(extent.isContentSized, isTrue);
      expect(extent.extent, 300);

      extent.applyDragDelta(40);
      expect(extent.extent, 300);
      expect(extent.dismissOffset, 40);

      extent.applyDragDelta(-10);
      expect(extent.dismissOffset, 30);
    });

    test('content-sized height is capped at 90% of the available height', () {
      final BottomSheetExtent extent = BottomSheetExtent(
        availableHeight: 1000,
        contentHeight: 980,
      );
      expect(extent.extent, 900);
    });

    test('updateAvailableHeight reclamps snap heights', () {
      final BottomSheetExtent extent = BottomSheetExtent(
        snapPoints: const [0.5, 1],
        availableHeight: 1000,
        initialSnapIndex: 1,
      );
      expect(extent.extent, 1000);

      extent.updateAvailableHeight(800);
      expect(extent.maxHeight, 800);
      expect(extent.extent, 800);
      expect(extent.minHeight, 400);
    });

    test('updateAvailableHeight keeps the current snap index', () {
      final BottomSheetExtent extent = BottomSheetExtent(
        snapPoints: const [0.4, 0.9],
        availableHeight: 1000,
      );
      expect(extent.extent, 400);
      extent.updateAvailableHeight(500);
      expect(extent.extent, 200);
      expect(extent.snapIndex, 0);
    });

    test('onSnapChanged fires when drag crosses a nearer snap', () {
      final List<int> indexes = [];
      final BottomSheetExtent extent = BottomSheetExtent(
        snapPoints: const [0.4, 0.9],
        availableHeight: 1000,
        initialSnapIndex: 1,
        onSnapChanged: indexes.add,
      );

      extent.applyDragDelta(200);
      expect(indexes, isEmpty);
      extent.applyDragDelta(200);
      expect(indexes, [0]);
    });
  });

  group('ComponentBottomSheet', () {
    testWidgets('phone sheet is full width with top corners rounded', (WidgetTester tester) async {
      await _openSheet(tester);
      final Size size = tester.getSize(_sheetFinder);
      expect(size.width, 400);
      expect(_sheetBorderRadius(tester), kModalTopBorderRadius);
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('sheet clips scrolling content to the rounded corners', (
      WidgetTester tester,
    ) async {
      await _openSheet(
        tester,
        float: true,
        showHandle: true,
        snapPoints: const [0.5, 0.9],
        slivers: _tallSlivers(),
      );
      expect(tester.widget<Material>(_sheetFinder).clipBehavior, Clip.antiAlias);
      expect(
        tester
            .widgetList<ClipRSuperellipse>(find.byType(ClipRSuperellipse))
            .any(
              (ClipRSuperellipse clip) =>
                  clip.clipBehavior == Clip.antiAliasWithSaveLayer &&
                  clip.borderRadius == AppDecoration.iOSModalBorderRadius,
            ),
        isTrue,
      );
    });

    testWidgets('grabber sits inside the faded sliver app bar', (WidgetTester tester) async {
      await _openSheet(tester, showHandle: true);
      const ValueKey<String> handleKey = ValueKey<String>('component-bottom-sheet-handle');
      expect(
        find.descendant(
          of: find.byType(ComponentSliverBlurredAppBar),
          matching: find.byKey(handleKey),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(ComponentSliverBlurredAppBar),
          matching: find.byType(ComponentSlideDownBar),
        ),
        findsOneWidget,
      );
      expect(
        tester.getRect(find.byKey(handleKey)).top,
        closeTo(tester.getRect(_sheetFinder).top, 0.5),
      );
    });

    testWidgets('content-sized sheet is capped at 90% of the available height', (
      WidgetTester tester,
    ) async {
      await _openSheet(tester, slivers: _tallSlivers());
      expect(tester.getSize(_sheetFinder).height, lessThanOrEqualTo(720.5));
    });

    testWidgets('phone floating sheet is inset with all corners rounded', (
      WidgetTester tester,
    ) async {
      await _openSheet(tester, float: true);
      final Rect rect = tester.getRect(_sheetFinder);
      expect(rect.width, 376);
      expect(rect.left, 12);
      expect(_sheetBorderRadius(tester), AppDecoration.iOSModalBorderRadius);
    });

    testWidgets('large screens float at 480px and never use a dialog', (WidgetTester tester) async {
      await _openSheet(tester, surfaceSize: const Size(1024, 800));
      expect(find.byType(Dialog), findsNothing);
      expect(tester.getSize(_sheetFinder).width, 480);
      expect(_sheetBorderRadius(tester), AppDecoration.iOSModalBorderRadius);
    });

    testWidgets('large screens honor left, center, and right placement', (
      WidgetTester tester,
    ) async {
      await _openSheet(
        tester,
        surfaceSize: const Size(1024, 800),
        placement: .left,
      );
      expect(tester.getTopLeft(_sheetFinder).dx, closeTo(24, 0.5));
      await tester.tap(find.byKey(const ValueKey<String>('modal-close')));
      await tester.pumpAndSettle();

      await _openSheet(
        tester,
        surfaceSize: const Size(1024, 800),
        placement: .right,
      );
      expect(tester.getTopLeft(_sheetFinder).dx, closeTo(520, 0.5));
      await tester.tap(find.byKey(const ValueKey<String>('modal-close')));
      await tester.pumpAndSettle();

      await _openSheet(
        tester,
        surfaceSize: const Size(1024, 800),
        placement: .center,
      );
      expect(tester.getTopLeft(_sheetFinder).dx, closeTo(272, 0.5));
    });

    testWidgets('dragging past half the sheet height dismisses it', (WidgetTester tester) async {
      await _openSheet(tester, showHandle: true);
      expect(_sheetFinder, findsOneWidget);

      await tester.timedDrag(
        find.byKey(const ValueKey<String>('component-bottom-sheet-handle')),
        const Offset(0, 400),
        const Duration(milliseconds: 300),
      );
      await tester.pumpAndSettle();
      expect(_sheetFinder, findsNothing);
    });

    testWidgets('releasing a drag snaps to the next snap point', (WidgetTester tester) async {
      await _openSheet(
        tester,
        snapPoints: const [0.4, 0.9],
        slivers: _tallSlivers(),
      );
      final double startHeight = tester.getSize(_sheetFinder).height;
      expect(startHeight, closeTo(320, 8));

      await tester.timedDrag(
        find.text('Item 0'),
        const Offset(0, -280),
        const Duration(milliseconds: 250),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(_sheetFinder).height, closeTo(720, 16));
    });

    testWidgets('dragging down at the top of the list collapses the sheet', (
      WidgetTester tester,
    ) async {
      await _openSheet(
        tester,
        snapPoints: const [0.4, 0.9],
        initialSnapIndex: 1,
        slivers: _tallSlivers(),
      );
      expect(tester.getSize(_sheetFinder).height, closeTo(720, 16));

      await tester.timedDrag(
        find.text('Item 0'),
        const Offset(0, 280),
        const Duration(milliseconds: 250),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(_sheetFinder).height, closeTo(320, 16));
    });

    testWidgets('controller expand, collapse, and close drive the sheet', (
      WidgetTester tester,
    ) async {
      final ComponentBottomSheetController controller = ComponentBottomSheetController();
      await _openSheet(
        tester,
        snapPoints: const [0.4, 0.9],
        controller: controller,
        slivers: _tallSlivers(),
      );
      expect(controller.isAttached, isTrue);
      expect(tester.getSize(_sheetFinder).height, closeTo(320, 8));

      controller.expand();
      await tester.pumpAndSettle();
      expect(tester.getSize(_sheetFinder).height, closeTo(720, 16));
      expect(controller.snapIndex, 1);

      controller.collapse();
      await tester.pumpAndSettle();
      expect(tester.getSize(_sheetFinder).height, closeTo(320, 16));
      expect(controller.snapIndex, 0);

      controller.close();
      await tester.pumpAndSettle();
      expect(_sheetFinder, findsNothing);
      expect(controller.isAttached, isFalse);
    });

    testWidgets('footer stays above the keyboard', (WidgetTester tester) async {
      await _openSheet(
        tester,
        snapPoints: const [0.6],
        footer: const Text('Submit'),
      );
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(tester.getRect(find.text('Submit')).bottom, lessThanOrEqualTo(500.5));
    });

    testWidgets('Navigator.pop completes show with a result', (WidgetTester tester) async {
      String? result;
      await pumpComponentApp(
        tester,
        child: Builder(
          builder: (BuildContext context) {
            return FilledButton(
              onPressed: () async {
                result = await ComponentBottomSheet.show<String>(
                  context: context,
                  builder: (BuildContext modalContext) {
                    return ComponentResponsiveModalWidget(
                      title: 'Sheet',
                      actions: [
                        TextButton(
                          key: const ValueKey<String>('sheet-save'),
                          onPressed: () => Navigator.pop(modalContext, 'Ada'),
                          child: const Text('Save'),
                        ),
                      ],
                      slivers: const [
                        SliverToBoxAdapter(child: SizedBox(height: 120, child: Text('Sheet body'))),
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
      await tester.tap(find.byKey(const ValueKey<String>('sheet-save')));
      await tester.pumpAndSettle();
      expect(result, 'Ada');
    });

    testWidgets('dark floating sheets draw a border', (WidgetTester tester) async {
      await _openSheet(
        tester,
        surfaceSize: const Size(1024, 800),
        themeMode: ThemeMode.dark,
      );
      final RoundedSuperellipseBorder shape = _sheetShape(tester);
      expect(shape.side.style, BorderStyle.solid);
    });
  });
}

final Finder _sheetFinder = find.byKey(const ValueKey<String>('component-bottom-sheet'));

RoundedSuperellipseBorder _sheetShape(WidgetTester tester) {
  final Material material = tester.widget<Material>(_sheetFinder);
  return material.shape! as RoundedSuperellipseBorder;
}

BorderRadiusGeometry _sheetBorderRadius(WidgetTester tester) => _sheetShape(tester).borderRadius;

List<Widget> _tallSlivers() {
  return [
    SliverList.builder(
      itemCount: 30,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(height: 48, child: Text('Item $index'));
      },
    ),
  ];
}

Future<void> _openSheet(
  WidgetTester tester, {
  Size surfaceSize = const Size(400, 800),
  List<double>? snapPoints,
  int initialSnapIndex = 0,
  bool float = false,
  ComponentBottomSheetPlacement placement = .center,
  bool showHandle = false,
  Widget? footer,
  ComponentBottomSheetController? controller,
  ThemeMode themeMode = ThemeMode.light,
  List<Widget>? slivers,
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await pumpComponentApp(
    tester,
    surfaceSize: surfaceSize,
    themeMode: themeMode,
    child: Builder(
      builder: (BuildContext context) {
        return FilledButton(
          onPressed: () {
            ComponentBottomSheet.show<void>(
              context: context,
              snapPoints: snapPoints,
              initialSnapIndex: initialSnapIndex,
              float: float,
              placement: placement,
              showHandle: showHandle,
              controller: controller,
              builder: (BuildContext modalContext) {
                return ComponentResponsiveModalWidget(
                  title: 'Sheet',
                  footer: footer,
                  slivers:
                      slivers ??
                      const [
                        SliverToBoxAdapter(
                          child: SizedBox(height: 200, child: Text('Sheet body')),
                        ),
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
