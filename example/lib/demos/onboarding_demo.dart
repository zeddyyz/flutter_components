import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class OnboardingDemoPage extends StatelessWidget {
  const OnboardingDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ComponentOnboardingCarousel(
          backgroundColor: context.scaffoldBackgroundColor,
          buttonColor: const Color(0xFF2F80ED),
          screenBorderRadius: BorderRadius.zero,
          imageHeightPercentage: 0.42,
          textPadding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
          skipButtonLabel: 'Skip',
          onSkip: () => Navigator.of(context).maybePop(),
          pages: const [
            OnboardingPage(
              imagePath: 'assets/onboarding/slide_1.png',
              title: 'Browse the catalog',
              description: 'Every widget in flutter_components has a screen you can tap through.',
            ),
            OnboardingPage(
              imagePath: 'assets/onboarding/slide_2.png',
              title: 'Resize freely',
              description:
                  'Sheets become dialogs on larger windows. Try it on iPad, macOS, or web.',
            ),
            OnboardingPage(
              imagePath: 'assets/onboarding/slide_3.png',
              title: 'Toggle the theme',
              description: 'Use the sun/moon control in the app bar to switch light and dark.',
            ),
          ],
          onDone: () => Navigator.of(context).maybePop(),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ComponentCloseButton.blurred(
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
