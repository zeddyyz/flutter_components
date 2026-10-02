import 'package:flutter_components/component_list_tile.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentRadioOption<T> {
  const ComponentRadioOption({
    required this.value,
    required this.label,
    this.subtitle,
  });

  final T value;
  final String label;
  final String? subtitle;
}

class ComponentRadioGroup<T> extends StatelessWidget {
  const ComponentRadioGroup({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.header,
  });

  final T value;
  final List<ComponentRadioOption<T>> options;
  final ValueChanged<T> onChanged;
  final String? header;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              header!,
              style: context.labelHeavy.copyWith(color: context.componentTheme.hintColor),
            ),
          ),
        ],
        for (int i = 0; i < options.length; i++) ...[
          ComponentListTile(
            key: ValueKey<String>('radio-$i'),
            title: Text(options[i].label),
            subtitle: options[i].subtitle == null ? null : Text(options[i].subtitle!),
            onTap: () => onChanged(options[i].value),
            trailing: _RadioMark(selected: options[i].value == value),
          ),
          if (i != options.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final Color active = Theme.of(context).primaryColor;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 22,
      height: 22,
      decoration: ShapeDecoration(
        shape: RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusStadium,
          side: BorderSide(
            color: selected ? active : context.componentTheme.borderColorIntense,
            width: selected ? 6 : 1.5,
          ),
        ),
      ),
    );
  }
}
