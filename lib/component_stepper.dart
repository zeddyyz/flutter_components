import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentStepper extends StatelessWidget {
  const ComponentStepper({
    super.key,
    required this.labels,
    required this.currentStep,
  });

  final List<String> labels;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < labels.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                color: i <= currentStep
                    ? Theme.of(context).primaryColor
                    : context.componentTheme.chipColor,
              ),
            ),
          _StepDot(
            index: i,
            label: labels[i],
            state: i < currentStep
                ? _StepState.complete
                : i == currentStep
                ? _StepState.current
                : _StepState.upcoming,
          ),
        ],
      ],
    );
  }
}

enum _StepState { complete, current, upcoming }

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.index,
    required this.label,
    required this.state,
  });

  final int index;
  final String label;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (state) {
      _StepState.complete || _StepState.current => Theme.of(context).primaryColor,
      _StepState.upcoming => context.componentTheme.chipColor,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedSuperellipseBorder(
              borderRadius: AppDecoration.borderRadiusStadium,
            ),
          ),
          child: state == _StepState.complete
              ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
              : Text(
                  '${index + 1}',
                  style: context.labelHeavy.copyWith(
                    color: state == _StepState.upcoming ? context.primary : Colors.white,
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: context.labelMedium.copyWith(
            color: state == _StepState.upcoming ? context.hintIntense : context.primary,
          ),
        ),
      ],
    );
  }
}
