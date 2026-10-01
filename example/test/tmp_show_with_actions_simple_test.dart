import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

double? lastBottomPadding;

final Finder _appBarBox = find.descendant(
  of: find.byType(SliverAppBar),
  matching: find.byType(AppBar),
);

class _Form extends StatefulWidget {
  const _Form({required this.hasLargeTitle});
  final bool hasLargeTitle;
  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final TextEditingController _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lastBottomPadding = MediaQuery.paddingOf(context).bottom;
    final actions = [
      TextButton(
        key: const ValueKey('save'),
        onPressed: _name.text.isEmpty ? null : () => Navigator.pop(context, _name.text),
        child: const Text('Save'),
      ),
    ];
    final slivers = [
      SliverToBoxAdapter(
        child: TextField(key: const ValueKey('field'), controller: _name),
      ),
      SliverList.builder(
        itemCount: 40,
        itemBuilder: (context, i) => SizedBox(height: 50, child: Text('row $i')),
      ),
    ];
    return widget.hasLargeTitle
        ? ComponentResponsiveModalWidget.largeTitle(
            title: 'Edit name',
            actions: actions,
            slivers: slivers,
          )
        : ComponentResponsiveModalWidget(title: 'Edit name', actions: actions, slivers: slivers);
  }
}

Future<Future<String?>> _open(
  WidgetTester tester, {
  required Size size,
  bool hasLargeTitle = false,
  bool float = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.view.padding = const FakeViewPadding(bottom: 34, top: 47);
  tester.view.viewPadding = const FakeViewPadding(bottom: 34, top: 47);
  addTearDown(tester.view.reset);

  late Future<String?> result;
  await tester.pumpWidget(
    Builder(
      builder: (rootContext) => MaterialApp(
        theme: AppThemeData.lightTheme(
          context: rootContext,
          primaryColor: Colors.blue,
          secondaryColor: Colors.grey,
        ),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => result = ComponentResponsiveModal.showWithActionsSimple<String>(
                  context: context,
                  float: float,
                  builder: (_) => _Form(hasLargeTitle: hasLargeTitle),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return Future.value(result);
}

Future<void> _expectActionFlow(WidgetTester tester, Future<String?> result) async {
  expect(tester.widget<TextButton>(find.byKey(const ValueKey('save'))).onPressed, isNull);
  await tester.enterText(find.byKey(const ValueKey('field')), 'Grace');
  await tester.pump();
  expect(tester.widget<TextButton>(find.byKey(const ValueKey('save'))).onPressed, isNotNull);
  await tester.tap(find.byKey(const ValueKey('save')));
  await tester.pumpAndSettle();
  expect(await result, 'Grace');
}

void main() {
  testWidgets('dialog: blurred bar, no safe-area padding, actions read state', (tester) async {
    final result = await _open(tester, size: const Size(1200, 900));
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.byType(ComponentSliverBlurredAppBar), findsOneWidget);
    expect(tester.getSize(find.byType(CustomScrollView)).width, 560);
    expect(lastBottomPadding, 0);
    final barTop = tester.getTopLeft(_appBarBox).dy;
    final dialogTop = tester.getTopLeft(find.byType(CustomScrollView)).dy;
    expect(barTop, dialogTop, reason: 'no status bar inset inside the dialog');
    expect(tester.getSize(_appBarBox).height, kModalToolbarHeight);
    await _expectActionFlow(tester, result);
  });

  testWidgets('dialog: large title collapses on scroll', (tester) async {
    final result = await _open(tester, size: const Size(1200, 900), hasLargeTitle: true);
    expect(find.byType(ComponentSliverLargeTitleAppBar), findsOneWidget);
    expect(find.text('Edit name'), findsNWidgets(2));
    final expanded = tester.getSize(_appBarBox).height;
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
    final collapsed = tester.getSize(_appBarBox).height;
    expect(collapsed, kToolbarHeight);
    expect(expanded, greaterThan(collapsed));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 2000));
    await tester.pumpAndSettle();
    await _expectActionFlow(tester, result);
  });

  testWidgets('sheet: keeps bottom safe area, no top inset', (tester) async {
    final result = await _open(tester, size: const Size(430, 932));
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
    expect(lastBottomPadding, 34);
    expect(tester.getSize(_appBarBox).height, kModalToolbarHeight);
    await _expectActionFlow(tester, result);
  });

  testWidgets('floating sheet: margin owns the bottom safe area', (tester) async {
    final result = await _open(tester, size: const Size(430, 932), float: true);
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(lastBottomPadding, 0);
    await _expectActionFlow(tester, result);
  });

  testWidgets('sheet: large title with keyboard inset does not overflow', (tester) async {
    final result = await _open(tester, size: const Size(430, 932), hasLargeTitle: true);
    tester.view.viewInsets = const FakeViewPadding(bottom: 336);
    await tester.pumpAndSettle();
    await _expectActionFlow(tester, result);
  });
}
