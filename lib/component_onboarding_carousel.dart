import 'package:flutter/material.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

/// Single slide in a [PaginatedOnboardingCarousel].
class OnboardingPage {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

/// Full-screen paged onboarding UI with Next / Done actions.
class PaginatedOnboardingCarousel extends StatefulWidget {
  const PaginatedOnboardingCarousel({
    super.key,
    required this.pages,
    required this.onDone,
    this.nextButtonLabel = 'Next',
    this.doneButtonLabel = 'Done',
    this.onBeforeAdvanceToNextPage,
    required this.buttonColor,
  });

  final List<OnboardingPage> pages;
  final VoidCallback onDone;
  final String nextButtonLabel;
  final String doneButtonLabel;
  final VoidCallback? onBeforeAdvanceToNextPage;
  final Color buttonColor;

  @override
  State<PaginatedOnboardingCarousel> createState() => _PaginatedOnboardingCarouselState();
}

class _PaginatedOnboardingCarouselState extends State<PaginatedOnboardingCarousel> {
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
      borderRadius: AppDecoration.borderRadiusLg,
      child: Scaffold(
        backgroundColor: context.bottomSheetTheme.backgroundColor,
        body: LayoutBuilder(
          builder: (context, bodyConstraints) {
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: pageCount,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return _OnboardingSlideLayout(
                  page: widget.pages[index],
                );
              },
            );
          },
        ),
        bottomNavigationBar: _OnboardingBottomBar(
          isLastPage: isLastPage,
          nextButtonLabel: widget.nextButtonLabel,
          doneButtonLabel: widget.doneButtonLabel,
          buttonColor: widget.buttonColor,
          onNextTap: _goToNextPage,
          onDoneTap: widget.onDone,
        ),
      ),
    );
  }
}

class _OnboardingSlideLayout extends StatelessWidget {
  final OnboardingPage page;

  const _OnboardingSlideLayout({
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    final bool isLargeScreen = !context.isMobile;
    final bool isPortrait = context.isPortraitView;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 28 : 48),
      child: SafeArea(
        bottom: false,
        minimum: EdgeInsets.only(top: isMobile ? kToolbarHeight + 40 : 32),
        child: isMobile || isLargeScreen && isPortrait
            ? _buildMobileContent(context)
            : _buildTabletContent(context),
      ),
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double imageHeight = constraints.maxHeight * 0.7;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                SizedBox(
                  height: imageHeight,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 44),
                      child: Image.asset(
                        page.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
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
            ),
          ),
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
        onTap: widget.isLastPage ? widget.onDoneTap : widget.onNextTap,
        child: Container(
          constraints: isMobile ? null : const BoxConstraints(minWidth: 160),
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 16 : 14,
            horizontal: isMobile ? 0 : 48,
          ),
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
          child: isMobile
              ? button
              : Align(
                  alignment: Alignment.centerRight,
                  child: button,
                ),
        ),
      ),
    );
  }
}
