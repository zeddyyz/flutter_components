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
            ],
          ),
        ),
        DemoSection(
          title: 'ComponentDialogWidget',
          child: OutlinedButton(
            key: const ValueKey<String>('dialog-show'),
            onPressed: () => _showDialog(context),
            child: const Text('Show dialog'),
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
                  child: SlideDownBar(),
                ),
                const ComponentBottomSheetHeader(title: 'Sheet title'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Text(
                    'ComponentBottomSheetHeader + SlideDownBar',
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

  Future<void> _showDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ComponentDialogWidget(
          height: 280,
          icon: Icon(Icons.info_outline_rounded, color: context.primary),
          title: 'Replace file?',
          description: 'This cannot be undone.',
          confirmText: 'Replace',
          cancelText: 'Cancel',
          onConfirm: () => Navigator.pop(dialogContext),
          onCancel: () => Navigator.pop(dialogContext),
        );
      },
    );
  }

  Future<void> _showFullScreen(BuildContext context) {
    return showComponentFullScreenWidget<void>(
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
