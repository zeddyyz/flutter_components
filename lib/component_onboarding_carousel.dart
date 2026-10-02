import 'package:flutter_components/component_page_indicator.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

/// Single slide in a [ComponentOnboardingCarousel].
class ComponentOnboardingPage {
  final String imagePath;
  final String title;
  final String description;

  const ComponentOnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

typedef OnboardingPage = ComponentOnboardingPage;

/// Full-screen paged onboarding UI with Next / Done actions.
class ComponentOnboardingCarousel extends StatefulWidget {
  const ComponentOnboardingCarousel({
    super.key,
    required this.pages,
    required this.onDone,
    this.nextButtonLabel = 'Next',
    this.doneButtonLabel = 'Done',
    this.skipButtonLabel = 'Skip',
    this.onSkip,
    this.onBeforeAdvanceToNextPage,
    required this.buttonColor,
    this.imagePadding,
    required this.backgroundColor,
    required this.screenBorderRadius,
    this.imageHeightPercentage,
  }) : assert(
         imageHeightPercentage == null || (imageHeightPercentage > 0 && imageHeightPercentage <= 1),
         'imageHeightPercentage must be between 0 (exclusive) and 1 (inclusive).',
       );

  final List<ComponentOnboardingPage> pages;
  final VoidCallback onDone;
  final String nextButtonLabel;
  final String doneButtonLabel;
  final String skipButtonLabel;
  final VoidCallback? onSkip;
  final VoidCallback? onBeforeAdvanceToNextPage;
  final Color buttonColor;
  final EdgeInsets? imagePadding;
  final Color backgroundColor;
  final BorderRadius screenBorderRadius;

  /// Optional cap on image height as a fraction of the slide (0–1).
  /// When null, the image uses whatever space remains after the text.
  final double? imageHeightPercentage;

  @override
  State<ComponentOnboardingCarousel> createState() => _ComponentOnboardingCarouselState();
}

class _ComponentOnboardingCarouselState extends State<ComponentOnboardingCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    widget.onBeforeAdvanceToNextPage?.call();
    final int pageCount = widget.pages.length;
    if (_currentPage < pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.pages.isNotEmpty,
      'PaginatedOnboardingCarousel requires at least one page.',
    );
    final int pageCount = widget.pages.length;
    final bool isLastPage = _currentPage == pageCount - 1;

    return ClipRSuperellipse(
      borderRadius: widget.screenBorderRadius,
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            spacing: 12,
            children: [
              SizedBox(
                height: 65,
                child: widget.onSkip == null
                    ? null
                    : _OnboardingSkipButton(
                        label: widget.skipButtonLabel,
                        isVisible: !isLastPage,
                        onTap: widget.onSkip!,
                      ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: pageCount,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    return _OnboardingSlideLayout(
                      page: widget.pages[index],
                      imagePadding: widget.imagePadding ?? EdgeInsets.zero,
                      imageHeightPercentage: widget.imageHeightPercentage,
                      textPadding: const EdgeInsets.fromLTRB(8, 24, 8, 40),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            ComponentPageIndicator(
              count: pageCount,
              index: _currentPage,
              activeColor: widget.buttonColor,
            ),
            _OnboardingBottomBar(
              isLastPage: isLastPage,
              nextButtonLabel: widget.nextButtonLabel,
              doneButtonLabel: widget.doneButtonLabel,
              buttonColor: widget.buttonColor,
              onNextTap: _goToNextPage,
              onDoneTap: widget.onDone,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlideLayout extends StatelessWidget {
  const _OnboardingSlideLayout({
    required this.page,
    required this.imagePadding,
    required this.imageHeightPercentage,
    required this.textPadding,
  });

  final ComponentOnboardingPage page;
  final EdgeInsets imagePadding;
  final double? imageHeightPercentage;
  final EdgeInsetsGeometry textPadding;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    final bool isLargeScreen = !context.isMobile;
    final bool isPortrait = context.isPortraitView;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 28 : 48,
        isMobile ? 8 : 32,
        isMobile ? 28 : 48,
        0,
      ),
      child: isMobile || isLargeScreen && isPortrait
          ? _buildMobileContent(context)
          : _buildTabletContent(context),
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double? maxImageHeight = imageHeightPercentage == null
            ? null
            : constraints.maxHeight * imageHeightPercentage!;

        return Column(
          children: [
            Flexible(
              child: Padding(
                padding: imagePadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: maxImageHeight ?? constraints.maxHeight,
                  ),
                  child: Image.asset(
                    page.imagePath,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Padding(
              padding: textPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    page.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    page.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.hintIntense,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabletContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Image.asset(
              page.imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page.title,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: context.isMobile ? null : 28,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  page.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.hintIntense,
                    height: 1.5,
                    fontSize: context.isMobile ? null : 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingSkipButton extends StatelessWidget {
  const _OnboardingSkipButton({
    required this.label,
    required this.isVisible,
    required this.onTap,
  });

  final String label;
  final bool isVisible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IgnorePointer(
        ignoring: !isVisible,
        child: AnimatedOpacity(
          opacity: isVisible ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: EdgeInsets.only(right: context.isMobile ? 12 : 24),
            child: ComponentGestureClick(
              key: const ValueKey('onboarding-skip'),
              onTap: onTap,
              semanticsLabel: label,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.hintIntense,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingBottomBar extends StatefulWidget {
  const _OnboardingBottomBar({
    required this.isLastPage,
    required this.nextButtonLabel,
    required this.doneButtonLabel,
    required this.buttonColor,
    required this.onNextTap,
    required this.onDoneTap,
  });

  final bool isLastPage;
  final String nextButtonLabel;
  final String doneButtonLabel;
  final Color buttonColor;
  final VoidCallback onNextTap;
  final VoidCallback onDoneTap;

  @override
  State<_OnboardingBottomBar> createState() => _OnboardingBottomBarState();
}

class _OnboardingBottomBarState extends State<_OnboardingBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant _OnboardingBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLastPage && !oldWidget.isLastPage) {
      _scaleController.forward().then((_) => _scaleController.reverse());
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String buttonText = widget.isLastPage ? widget.doneButtonLabel : widget.nextButtonLabel;

    final bool isMobile = context.isMobile;

    final Widget button = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: ComponentGestureClick(
        key: ValueKey(widget.isLastPage ? 'onboarding-done' : 'onboarding-next'),
        onTap: widget.isLastPage ? widget.onDoneTap : widget.onNextTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: isMobile ? 16 : 14),
          decoration: ShapeDecoration(
            color: widget.buttonColor,
            shape: RoundedSuperellipseBorder(
              borderRadius: AppDecoration.borderRadiusStadium,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              buttonText,
              key: ValueKey<String>(buttonText),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: context.isMobile ? null : 20,
              ),
            ),
          ),
        ),
      ),
    );

    return SizedBox(
      height: isMobile ? null : 100,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 40 : 48,
            8,
            isMobile ? 40 : 48,
            16,
          ),
          child: button,
        ),
      ),
    );
  }
}
