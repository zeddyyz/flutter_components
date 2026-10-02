import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentSegment<T> {
  const ComponentSegment({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final Widget? icon;
}

class ComponentSegmentedControl<T> extends StatelessWidget {
  const ComponentSegmentedControl({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
  }) : assert(segments.length >= 2, 'ComponentSegmentedControl requires at least 2 segments.');

  final List<ComponentSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  static const Duration _thumbDuration = Duration(milliseconds: 220);

  int get _selectedIndex {
    final int index = segments.indexWhere(
      (ComponentSegment<T> segment) => segment.value == value,
    );
    return index < 0 ? 0 : index;
  }

  static Alignment _thumbAlignment(int index, int count) {
    if (count <= 1) {
      return Alignment.center;
    }
    return Alignment(-1.0 + (2.0 * index / (count - 1)), 0);
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _selectedIndex;
    final int segmentCount = segments.length;

    return SizedBox(
      width: double.infinity,
      height: AppDecoration.pillTrackHeight,
      child: ClipRSuperellipse(
        borderRadius: AppDecoration.borderRadiusStadium,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: AppDecoration.pillTrackColor(context),
            shape: const RoundedSuperellipseBorder(
              borderRadius: AppDecoration.borderRadiusStadium,
            ),
          ),
          child: Padding(
            padding: AppDecoration.pillTrackPadding,
            child: Stack(
              fit: StackFit.expand,
              children: [
                RepaintBoundary(
                  child: AnimatedAlign(
                    alignment: _thumbAlignment(selectedIndex, segmentCount),
                    duration: _thumbDuration,
                    curve: Curves.easeOutCubic,
                    child: FractionallySizedBox(
                      widthFactor: 1 / segmentCount,
                      heightFactor: 1,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: AppDecoration.pillThumbColor(context),
                          shape: const RoundedSuperellipseBorder(
                            borderRadius: AppDecoration.borderRadiusStadium,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int index = 0; index < segmentCount; index++)
                      Expanded(
                        child: _SegmentButton<T>(
                          key: ValueKey<String>('segment-$index'),
                          segment: segments[index],
                          isSelected: index == selectedIndex,
                          onPressed: () {
                            final T nextValue = segments[index].value;
                            if (nextValue != value) {
                              onChanged(nextValue);
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SegmentButton<T> extends StatelessWidget {
  const _SegmentButton({
    super.key,
    required this.segment,
    required this.isSelected,
    required this.onPressed,
  });

  final ComponentSegment<T> segment;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color labelColor = isSelected ? context.primary : context.primary.withValues(alpha: 0.6);
    final TextStyle style = (context.textTheme.bodyMedium ?? context.bodyMedium).copyWith(
      color: labelColor,
    );

    return Semantics(
      button: true,
      selected: isSelected,
      child: ComponentGestureClick(
        onTap: onPressed,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IconTheme(
              data: IconThemeData(size: 16, color: style.color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (segment.icon != null) ...[
                    segment.icon!,
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Text(
                      segment.label,
                      style: style,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
