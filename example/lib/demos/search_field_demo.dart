import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class SearchFieldDemoPage extends StatefulWidget {
  const SearchFieldDemoPage({super.key});

  @override
  State<SearchFieldDemoPage> createState() => _SearchFieldDemoPageState();
}

class _SearchFieldDemoPageState extends State<SearchFieldDemoPage> {
  final TextEditingController _basicController = TextEditingController();
  final TextEditingController _cancelController = TextEditingController();
  final TextEditingController _debounceController = TextEditingController();

  String? _lastEmittedQuery;

  @override
  void dispose() {
    _basicController.dispose();
    _cancelController.dispose();
    _debounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Search field',
      children: [
        DemoSection(
          title: 'Basic',
          description: 'Leading search icon and a clear control once text is entered.',
          child: ComponentSearchField(
            controller: _basicController,
          ),
        ),
        DemoSection(
          title: 'With cancel',
          description: 'Cancel clears the query, unfocuses the field, and invokes onCancel.',
          child: ComponentSearchField(
            controller: _cancelController,
            showCancelButton: true,
            onCancel: () {},
          ),
        ),
        DemoSection(
          title: 'Debounced',
          description: 'onChanged fires 400ms after typing stops.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ComponentSearchField(
                controller: _debounceController,
                debounce: const Duration(milliseconds: 400),
                onChanged: (String query) {
                  setState(() => _lastEmittedQuery = query);
                },
              ),
              const SizedBox(height: 12),
              Text(
                'Last emitted query: ${_lastEmittedQuery ?? '—'}',
                style: context.bodyMedium.copyWith(color: context.hintIntense),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
