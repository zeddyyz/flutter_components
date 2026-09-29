import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class TextFieldDemoPage extends StatefulWidget {
  const TextFieldDemoPage({super.key});

  @override
  State<TextFieldDemoPage> createState() => _TextFieldDemoPageState();
}

class _TextFieldDemoPageState extends State<TextFieldDemoPage> {
  final TextEditingController _search = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  final TextEditingController _simple = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    _email.dispose();
    _amount.dispose();
    _notes.dispose();
    _simple.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Text field',
      children: [
        DemoSection(
          title: 'Default',
          child: ComponentTextField(
            controller: _search,
            hintText: 'Search',
            icon: const Icon(Icons.search_rounded),
            textInputAction: TextInputAction.next,
          ),
        ),
        DemoSection(
          title: 'Filled',
          child: ComponentTextField(
            controller: _email,
            hintText: 'Email',
            icon: const Icon(Icons.mail_outline_rounded),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            backgroundColor: context.cardColor,
          ),
        ),
        DemoSection(
          title: 'Error',
          child: ComponentTextField(
            controller: _amount,
            hintText: 'Amount',
            icon: const Icon(Icons.payments_outlined),
            prefixText: '\$ ',
            isError: true,
            keyboardType: TextInputType.number,
          ),
        ),
        DemoSection(
          title: 'Multiline',
          child: ComponentTextField(
            controller: _notes,
            hintText: 'Notes',
            icon: const Icon(Icons.notes_rounded),
            maxLines: 4,
          ),
        ),
        DemoSection(
          title: 'Simple',
          child: ComponentTextField(
            controller: _simple,
            hintText: 'Simple',
            icon: const Icon(Icons.notes_rounded),
            showSimple: true,
            showClearTextButton: true,
          ),
        ),
        DemoSection(
          title: 'Simple Error',
          child: ComponentTextField(
            controller: _simple,
            hintText: 'Simple',
            icon: const Icon(Icons.notes_rounded),
            showSimple: true,
            showClearTextButton: true,
            isError: true,
          ),
        ),
      ],
    );
  }
}
