import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

const Duration _kStepAnimationDuration = Duration(milliseconds: 280);
const Curve _kStepAnimationCurve = Curves.easeOutCubic;

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
              child: _StepConnector(
                key: ValueKey<String>('stepper.connector.$i'),
                filled: i <= currentStep,
              ),
            ),
          _StepDot(
            key: ValueKey<String>('stepper.dot.$i'),
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

class _StepConnector extends StatelessWidget {
  const _StepConnector({
    super.key,
    required this.filled,
  });

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: Stack(
        fit: .expand,
        children: [
          ColoredBox(color: context.componentTheme.chipColor),
          AnimatedFractionallySizedBox(
            duration: _kStepAnimationDuration,
            curve: _kStepAnimationCurve,
            alignment: .centerLeft,
            widthFactor: filled ? 1 : 0,
            child: ColoredBox(color: Theme.of(context).primaryColor),
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    super.key,
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
    final TextStyle labelStyle = (context.textTheme.labelMedium ?? const TextStyle()).copyWith(
      color: state == _StepState.upcoming ? context.hintIntense : context.primary,
    );

    return Column(
      mainAxisSize: .min,
      children: [
        AnimatedContainer(
          duration: _kStepAnimationDuration,
          curve: _kStepAnimationCurve,
          width: 28,
          height: 28,
          alignment: .center,
          decoration: ShapeDecoration(
            color: color,
            shape: const RoundedSuperellipseBorder(
              borderRadius: AppDecoration.borderRadiusStadium,
            ),
          ),
          child: AnimatedSwitcher(
            duration: _kStepAnimationDuration,
            switchInCurve: _kStepAnimationCurve,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (Widget child, Animation<double> animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: state == _StepState.complete
                ? const Icon(
                    Icons.check_rounded,
                    key: ValueKey<String>('check'),
                    size: 16,
                    color: Colors.white,
                  )
                : AnimatedDefaultTextStyle(
                    key: const ValueKey<String>('number'),
                    duration: _kStepAnimationDuration,
                    curve: _kStepAnimationCurve,
                    style: (context.textTheme.labelLarge?.semibold ?? const TextStyle()).copyWith(
                      color: state == _StepState.upcoming ? context.primary : Colors.white,
                    ),
                    child: Text('${index + 1}'),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        AnimatedDefaultTextStyle(
          duration: _kStepAnimationDuration,
          curve: _kStepAnimationCurve,
          style: labelStyle,
          child: Text(label),
        ),
      ],
    );
  }
}
