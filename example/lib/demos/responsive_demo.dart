import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class ResponsiveDemoPage extends StatelessWidget {
  const ResponsiveDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    String breakpoint;
    if (context.isMobile) {
      breakpoint = 'mobile (≤ ${AppScreenSize.small.toInt()}px)';
    } else if (context.isMediumScreen) {
      breakpoint = 'medium (≤ ${AppScreenSize.medium.toInt()}px)';
    } else if (context.isLargeScreen) {
      breakpoint = 'large (≤ ${AppScreenSize.large.toInt()}px)';
    } else {
      breakpoint = 'extra-large (> ${AppScreenSize.large.toInt()}px)';
    }

    return DemoScaffold(
      title: 'Responsive',
      children: [
        DemoSection(
          title: 'Current window',
          child: ComponentCard(
            displayBorder: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.viewWidth.toStringAsFixed(0)} × ${context.viewHeight.toStringAsFixed(0)}',
                  style: context.displayHeavy,
                ),
                const SizedBox(height: 8),
                Text(breakpoint, style: context.bodyMedium.copyWith(color: context.hintIntense)),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'ComponentResponsiveWidget',
          description: 'Resize the window to swap the child.',
          child: ComponentResponsiveWidget(
            mobile: _BreakpointCard(
              label: 'Mobile',
              color: Colors.blue.withValues(alpha: 0.2),
            ),
            medium: _BreakpointCard(
              label: 'Medium',
              color: Colors.teal.withValues(alpha: 0.2),
            ),
            large: _BreakpointCard(
              label: 'Large',
              color: Colors.orange.withValues(alpha: 0.2),
            ),
            xLarge: _BreakpointCard(
              label: 'Extra large',
              color: Colors.purple.withValues(alpha: 0.2),
            ),
          ),
        ),
      ],
    );
  }
}

class _BreakpointCard extends StatelessWidget {
  const _BreakpointCard({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      displayBorder: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppDecoration.borderRadiusLg,
          ),
        ),
        alignment: Alignment.center,
        child: Text(label, style: context.headlineHeavy),
      ),
    );
  }
}
