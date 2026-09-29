import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class SurfacesDemoPage extends StatefulWidget {
  const SurfacesDemoPage({super.key});

  @override
  State<SurfacesDemoPage> createState() => _SurfacesDemoPageState();
}

class _SurfacesDemoPageState extends State<SurfacesDemoPage> {
  int _selectedTile = 0;
  final Set<String> _selectedChips = {'Design'};

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Cards & tiles',
      children: [
        DemoSection(
          title: 'ComponentCard',
          child: Column(
            spacing: 12,
            children: [
              ComponentCard(
                displayBorder: true,
                onTap: () => AlertSnackbar.show(message: 'Bordered card'),
                child: Text('Bordered card', style: context.body2Heavy),
              ),
              ComponentCard(
                isInSheet: true,
                displayBorder: true,
                onTap: () => AlertSnackbar.show(message: 'Sheet card'),
                child: Text('Sheet card color', style: context.body2Heavy),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'ComponentListTile',
          description: 'Tap to change the selected tile.',
          child: ComponentNoSplashTheme(
            child: Column(
              spacing: 8,
              children: [
                for (int i = 0; i < 3; i++)
                  ComponentListTile(
                    key: ValueKey<String>('list-tile-$i'),
                    isSelected: _selectedTile == i,
                    displayBorder: true,
                    leading: Icon(Icons.folder_outlined, color: context.primary),
                    title: Text('Project ${i + 1}'),
                    subtitle: const Text('Updated just now'),
                    trailing: Icon(Icons.chevron_right_rounded, color: context.hint),
                    onTap: () => setState(() => _selectedTile = i),
                  ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'ComponentPill',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ComponentPill(
                key: const ValueKey<String>('pill-filter'),
                text: 'Filters',
                icon: Icon(Icons.tune_rounded, size: 18, color: context.primary),
                onTap: () => AlertSnackbar.show(message: 'Filters pill'),
              ),
              ComponentPill(
                key: const ValueKey<String>('pill-new'),
                text: 'New',
                color: Colors.blue,
                icon: const Icon(Icons.add_rounded, size: 18, color: Colors.blue),
                onTap: () => AlertSnackbar.show(message: 'New pill'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'ComponentFilterChip',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final String label in const ['Design', 'Engineering', 'Research'])
                ComponentFilterChip(
                  key: ValueKey<String>('chip-$label'),
                  label: label,
                  isSelected: _selectedChips.contains(label),
                  selectedColor: context.primary,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedChips.add(label);
                      } else {
                        _selectedChips.remove(label);
                      }
                    });
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
