import 'package:flutter_components/components_context_extension.dart';
import 'package:material_ui/material_ui.dart';

class ComponentRefreshControl extends StatelessWidget {
  const ComponentRefreshControl({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      backgroundColor: context.componentTheme.cardColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
