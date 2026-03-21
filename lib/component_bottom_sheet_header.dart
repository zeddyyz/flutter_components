import 'package:flutter/material.dart';
import 'package:flutter_components/component_close_button.dart';
import 'package:flutter_components/components_context_extension.dart';

class ComponentBottomSheetHeader extends StatelessWidget {
  const ComponentBottomSheetHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.defaultPadding, vertical: 8),
      color: context.bottomSheetTheme.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          ComponentCloseButton(),
        ],
      ),
    );
  }
}
