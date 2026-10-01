import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class OverlaysDemoPage extends StatelessWidget {
  const OverlaysDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Modals & alerts',
      children: [
        DemoSection(
          title: 'ComponentResponsiveModal',
          description: 'Sheet on phones, dialog on larger screens.',
          child: Column(
            spacing: 12,
            children: [
              FilledButton(
                key: const ValueKey<String>('modal-show'),
                onPressed: () => _showModal(context),
                child: const Text('Show modal'),
              ),
              OutlinedButton(
                key: const ValueKey<String>('modal-float'),
                onPressed: () => _showModal(context, float: true),
                child: const Text('Show floating modal'),
              ),
              ComponentLightButton(
                key: const ValueKey<String>('modal-scaffold'),
                onPressed: () => _showScaffoldModal(context),
                child: const Text('Show with scaffold'),
              ),
              ElevatedButton(
                key: const ValueKey<String>('modal-actions'),
                onPressed: () => _showActionsModal(context),
                child: const Text('Show with actions'),
              ),
              ElevatedButton(
                key: const ValueKey<String>('modal-actions-simple'),
                onPressed: () => _showSimpleActionsModal(context),
                child: const Text('Show with actions (simple)'),
              ),
              ElevatedButton(
                key: const ValueKey<String>('modal-actions-simple-large-title'),
                onPressed: () => _showSimpleActionsModal(context, hasLargeTitle: true),
                child: const Text('Show with actions (simple, large title)'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'ComponentDialogWidget',
          child: Column(
            spacing: 8,
            children: [
              OutlinedButton(
                key: const ValueKey<String>('dialog-show'),
                onPressed: () => _showDialog(context, blurBackground: false),
                child: const Text('Show dialog'),
              ),
              OutlinedButton(
                key: const ValueKey<String>('dialog-show-blurred'),
                onPressed: () => _showDialog(context, blurBackground: true),
                child: const Text('Show dialog with blurred background'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'AlertSnackbar',
          description: 'Stack up to three. Drag down to expand into a dialog.',
          child: Column(
            spacing: 12,
            children: [
              ComponentLightButton(
                key: const ValueKey<String>('snackbar-ok'),
                onPressed: () {
                  AlertSnackbar.show(title: 'Saved', message: 'Changes are in sync');
                },
                child: const Text('Success toast'),
              ),
              ComponentDangerButton(
                key: const ValueKey<String>('snackbar-error'),
                onPressed: () {
                  AlertSnackbar.show(
                    isError: true,
                    title: 'Could not save',
                    message: 'Check your connection and try again',
                  );
                },
                child: const Text('Error toast'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Full screen',
          child: OutlinedButton(
            key: const ValueKey<String>('fullscreen-show'),
            onPressed: () => _showFullScreen(context),
            child: const Text('Slide up full screen'),
          ),
        ),
        DemoSection(
          title: 'Sheet chrome',
          description: 'Header and drag indicator used inside custom sheets.',
          child: ComponentCard(
            displayBorder: true,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ComponentSlideDownBar(),
                ),
                const ComponentBottomSheetHeader(title: 'Sheet title'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Text(
                    'ComponentBottomSheetHeader + ComponentSlideDownBar',
                    style: context.bodyMedium.copyWith(color: context.hintIntense),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showModal(BuildContext context, {bool float = false}) {
    return ComponentResponsiveModal.show<void>(
      context: context,
      title: float ? 'Floating modal' : 'Modal',
      float: float,
      builder: (BuildContext modalContext) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, kModalToolbarHeight + 16, 20, 32),
          children: [
            Text(
              'Resize the window: phones get a sheet, larger screens get a dialog.',
              style: modalContext.bodyMedium,
            ),
            const SizedBox(height: 16),
            ComponentLightButton(
              isModalSheet: true,
              onPressed: () => Navigator.pop(modalContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showScaffoldModal(BuildContext context) {
    return ComponentResponsiveModal.showWithScaffold<void>(
      context: context,
      title: 'Scaffold modal',
      builder: (BuildContext modalContext, bool isDialog) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            isDialog ? 'Presented as a dialog' : 'Presented as a sheet',
            style: modalContext.bodyMedium,
          ),
        );
      },
    );
  }

  Future<void> _showActionsModal(BuildContext context) async {
    final String? name = await ComponentResponsiveModal.showWithActions<String>(
      context: context,
      title: 'Edit name',
      actionsBuilder: (BuildContext actionContext, ComponentModalController modal) {
        return [
          TextButton(
            key: const ValueKey<String>('modal-save'),
            onPressed: modal.isEnabled ? modal.invoke : null,
            child: modal.isBusy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ];
      },
      builder: (BuildContext modalContext) => const _NameForm(),
    );
    if (!context.mounted || name == null) return;
    AlertSnackbar.show(title: 'Saved', message: name);
  }

  Future<void> _showSimpleActionsModal(BuildContext context, {bool hasLargeTitle = false}) async {
    final String? name = await ComponentResponsiveModal.showWithActionsSimple<String>(
      context: context,
      builder: (BuildContext modalContext) => _SimpleNameForm(hasLargeTitle: hasLargeTitle),
    );
    if (!context.mounted || name == null) return;
    AlertSnackbar.show(title: 'Saved', message: name);
  }

  Future<void> _showDialog(BuildContext context, {bool blurBackground = false}) {
    return ComponentDialogWidget.show<void>(
      context: context,
      title: 'Replace file?',
      description: 'This cannot be undone.',
      confirmText: 'Replace',
      cancelText: 'Cancel',
      blurBackground: blurBackground,
      onConfirm: () => Navigator.pop(context),
    );
  }

  Future<void> _showFullScreen(BuildContext context) {
    return ComponentResponsiveModal.showFullScreen<void>(
      context: context,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: ComponentBlurredAppBar(
          context: context,
          title: const Text('Full screen'),
        ),
        body: Center(
          child: Text('Slid up from the bottom', style: context.body2Heavy),
        ),
      ),
    );
  }
}

class _NameForm extends StatefulWidget {
  const _NameForm();

  @override
  State<_NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<_NameForm> {
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

  Future<ComponentModalAction> _save() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return ComponentModalAction.close(_name.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    ComponentModalScope.of(context).attach(
      onInvoke: _save,
      isEnabled: _name.text.trim().isNotEmpty,
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, kModalToolbarHeight + 16, 20, 32),
      children: [
        ComponentTextField(
          controller: _name,
          hintText: 'Your name',
          icon: const Icon(Icons.person_outline_rounded),
        ),
      ],
    );
  }
}

class _SimpleNameForm extends StatefulWidget {
  const _SimpleNameForm({required this.hasLargeTitle});

  final bool hasLargeTitle;

  @override
  State<_SimpleNameForm> createState() => _SimpleNameFormState();
}

class _SimpleNameFormState extends State<_SimpleNameForm> {
  static const List<String> _suggestedNames = [
    'Ada Lovelace',
    'Alan Turing',
    'Barbara Liskov',
    'Dennis Ritchie',
    'Donald Knuth',
    'Edsger Dijkstra',
    'Frances Allen',
    'Grace Hopper',
    'Hedy Lamarr',
    'Katherine Johnson',
    'Ken Thompson',
    'Linus Torvalds',
    'Margaret Hamilton',
    'Radia Perlman',
    'Tim Berners-Lee',
  ];

  final TextEditingController _name = TextEditingController();
  bool _isSaving = false;

  bool get _canSave => _name.text.trim().isNotEmpty && !_isSaving;

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

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.pop(context, _name.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = [
      TextButton(
        key: const ValueKey<String>('modal-simple-save'),
        onPressed: _canSave ? _save : null,
        child: _isSaving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Save'),
      ),
    ];
    final List<Widget> slivers = [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        sliver: SliverToBoxAdapter(
          child: ComponentTextField(
            controller: _name,
            hintText: 'Your name',
            icon: const Icon(Icons.person_outline_rounded),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        sliver: SliverList.builder(
          itemCount: _suggestedNames.length,
          itemBuilder: (BuildContext context, int index) {
            final String suggestedName = _suggestedNames[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ComponentListTile(
                key: ValueKey<String>('suggested-name-$index'),
                isWithinBottomSheet: true,
                displayBorder: true,
                isSelected: _name.text == suggestedName,
                title: Text(suggestedName),
                onTap: () => _name.text = suggestedName,
              ),
            );
          },
        ),
      ),
    ];

    if (widget.hasLargeTitle) {
      return ComponentResponsiveModalWidget.largeTitle(
        title: 'Edit name',
        actions: actions,
        slivers: slivers,
      );
    }
    return ComponentResponsiveModalWidget(
      title: 'Edit name',
      actions: actions,
      slivers: slivers,
    );
  }
}
