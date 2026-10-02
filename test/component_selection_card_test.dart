import 'package:flutter_components/flutter_components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/pump_component_app.dart';

void main() {
  testWidgets('tapping a card invokes onTap', (WidgetTester tester) async {
    bool selected = false;

    await pumpComponentApp(
      tester,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ComponentSelectionCard(
            key: const ValueKey<String>('selection-notifications'),
            icon: const Icon(Icons.notifications_outlined),
            title: 'Notifications',
            selected: selected,
            onTap: () => setState(() => selected = !selected),
          );
        },
      ),
    );

    expect(find.byIcon(Icons.circle_outlined), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('selection-notifications')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('single-select group keeps one value', (WidgetTester tester) async {
    String plan = 'pro';

    await pumpComponentApp(
      tester,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ComponentSelectionGroup<String>(
            value: plan,
            onChanged: (String value) => setState(() => plan = value),
            options: const [
              ComponentSelectionOption(
                value: 'free',
                icon: Icon(Icons.person_outline_rounded),
                title: 'Free',
              ),
              ComponentSelectionOption(
                value: 'pro',
                icon: Icon(Icons.workspace_premium_outlined),
                title: 'Pro',
              ),
            ],
          );
        },
      ),
    );

    expect(
      tester
          .widget<ComponentSelectionCard>(find.byKey(const ValueKey<String>('selection-card-free')))
          .selected,
      isFalse,
    );
    expect(
      tester
          .widget<ComponentSelectionCard>(find.byKey(const ValueKey<String>('selection-card-pro')))
          .selected,
      isTrue,
    );

    await tester.tap(find.byKey(const ValueKey<String>('selection-card-free')));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<ComponentSelectionCard>(find.byKey(const ValueKey<String>('selection-card-free')))
          .selected,
      isTrue,
    );
    expect(
      tester
          .widget<ComponentSelectionCard>(find.byKey(const ValueKey<String>('selection-card-pro')))
          .selected,
      isFalse,
    );
  });

  testWidgets('multi-select group toggles membership', (WidgetTester tester) async {
    final Set<String> features = <String>{'analytics'};

    await pumpComponentApp(
      tester,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ComponentSelectionGroup<String>.multi(
            values: features,
            onValuesChanged: (Set<String> values) {
              setState(() {
                features
                  ..clear()
                  ..addAll(values);
              });
            },
            options: const [
              ComponentSelectionOption(
                value: 'analytics',
                icon: Icon(Icons.insights_outlined),
                title: 'Analytics',
              ),
              ComponentSelectionOption(
                value: 'sharing',
                icon: Icon(Icons.ios_share_rounded),
                title: 'Sharing',
              ),
            ],
          );
        },
      ),
    );

    expect(
      tester
          .widget<ComponentSelectionCard>(
            find.byKey(const ValueKey<String>('selection-card-analytics')),
          )
          .selected,
      isTrue,
    );
    expect(
      tester
          .widget<ComponentSelectionCard>(
            find.byKey(const ValueKey<String>('selection-card-sharing')),
          )
          .selected,
      isFalse,
    );

    await tester.tap(find.byKey(const ValueKey<String>('selection-card-sharing')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ComponentSelectionCard>(
            find.byKey(const ValueKey<String>('selection-card-sharing')),
          )
          .selected,
      isTrue,
    );

    await tester.tap(find.byKey(const ValueKey<String>('selection-card-analytics')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ComponentSelectionCard>(
            find.byKey(const ValueKey<String>('selection-card-analytics')),
          )
          .selected,
      isFalse,
    );
  });
}
